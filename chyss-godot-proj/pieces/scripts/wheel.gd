extends piece

#stood up wheel can be moved perpendicular to fall over, stands up in any direction to be able to roll again

#directions it can move when fallen over
var flatMoveVectors = [Vector2(0, 1),
					Vector2(0, -1),
					Vector2(1, 0),
					Vector2(-1, 0),
					Vector2(1, 1),
					Vector2(-1, 1),
					Vector2(1, -1),
					Vector2(-1, -1)]

#starts facing east-west
var facingVector = Vector2(1, 0)
var velocity = Vector2(0, 0)
var type = "Wheel"


var prevFacingVector = Vector2(1,0) #needed by animations, because facing vector is set before animations run
enum animFlags {ROLL_START, ROLL, STAND, FALL}
const animations = ['anim_roll_start', 'anim_roll', 'anim_stand', 'anim_fall']
var animFlag = animFlags.ROLL
var side_y_offset = 0.018

func individual_ready():
	model_offset = Vector3(0,.06,0)

func find_moves():
	#no valid moves if rolling
	if velocity != Vector2(0, 0):
		return []
	
	var validMoves = []
	#standing find moves
	if facingVector != Vector2(0, 0):
		var standingMoveVectors = [facingVector, facingVector*-1, facingVector.rotated(PI/2), facingVector.rotated(-PI/2)]
		for vector in standingMoveVectors:
			vector = vector.snapped(Vector2(1, 1))
			if can_move(vector) || can_take_teamless(vector):
				var capture = pieceParent.find_piece(vector+boardPosition)
				validMoves.append({team = team, piece = self, vector = vector, capture = capture, score = 0})
	#flat find moves
	else:
		for vector in flatMoveVectors:
			if can_move(vector):
				validMoves.append({team = team, piece = self, vector = vector, capture = null, score = 0})
	return validMoves
	

func move(movePosition):
	var moveVector = movePosition - boardPosition
	prevFacingVector = facingVector
	
	if moveVector == facingVector || moveVector == (facingVector * -1):
		velocity = moveVector
		animFlag = animFlags.ROLL_START
		return
	#laying -> standing
	if facingVector == Vector2(0, 0):
		facingVector = moveVector.rotated(PI/2)
		facingVector = facingVector.snapped(Vector2(1, 1))
		animFlag = animFlags.STAND
	else: #standing -> laying
		facingVector = Vector2(0, 0)
		animFlag = animFlags.FALL
		#look for a piece to capture
	var capturePiece = pieceParent.find_piece(movePosition)
	#must say self for setget to work
	self.boardPosition = movePosition
	#capture piece after moving, so that it knows your position when this runs
	if capturePiece:
		if capturePiece != self:
			capturePiece.get_captured()
	

#on next turn wheel rolls according to velocity
func next_turn(_currentTurn):
	if velocity != Vector2(0, 0):
		roll()

#function for the wheel to roll
func roll():
	#look for a piece to capture
	var rollPosition = velocity + boardPosition
	var capturePiece = pieceParent.find_piece(rollPosition)
	#must say self for setget to work
	self.boardPosition = rollPosition
	animFlag = animFlags.ROLL # after set position, so ROLL_START is preserved once
	#capture piece after moving, so that it knows your position when this runs
	if capturePiece:
		if capturePiece != self:
			capturePiece.get_captured()
	
	stop_check()
#function to stop the wheel's motion if it hits the edge of the board
func stop_check():
	if pieceParent.out_of_bounds(boardPosition + velocity):
		velocity = Vector2(0, 0)

func get_captured():
	velocity = Vector2(0, 0)
	boardPosition = Vector2(-1, -1)
	queue_free()


#animation functions:

func anim_fall(oldPosition: Vector3, newPosition: Vector3) -> void:
	newPosition.y = side_y_offset
	
	var moveVector = newPosition - oldPosition
	var moveVector2d = Vector2(moveVector.x, moveVector.z)
	
	rotation.y = _min_angle(-moveVector2d.angle() - (PI/2))
	
	var slide_percentage = .7
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.parallel().tween_property(self, "translation:x", lerp(oldPosition.x, newPosition.x, slide_percentage), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "translation:y", newPosition.y, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "translation:z", lerp(oldPosition.z, newPosition.z, slide_percentage), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "rotation:x", rotation.x -(PI/2), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.chain().tween_property(self, "translation", newPosition,1.52).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func anim_stand(_oldPosition: Vector3, newPosition: Vector3) -> void:
	rotation.y = _min_angle(-facingVector.angle())
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.parallel().tween_property(self, "translation", newPosition, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "rotation:x", rotation.x - (PI/2), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func anim_roll_start(_oldPosition: Vector3, newPosition: Vector3) -> void:
	#the . at the beginning tells it to use the base class's version
	.translate_tweened(newPosition) 

func anim_roll(_oldPosition: Vector3, newPosition: Vector3) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "translation", newPosition, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func translate_tweened(newPosition):
	newPosition += model_offset 
	call(animations[animFlag], self.translation, newPosition)


func _min_angle(inAngle : float) -> float:
	if inAngle < -PI:
		return inAngle + (2*PI)
	if inAngle > PI:
		return inAngle - (2*PI)
	return inAngle
