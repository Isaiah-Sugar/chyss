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


func find_moves():
	#no valid moves if rolling
	if velocity != Vector2(0, 0):
		return
	
	var validMoves = []
	#standing find moves
	if facingVector != Vector2(0, 0):
		var standingMoveVectors = [facingVector, facingVector*-1, facingVector.rotated(PI/2), facingVector.rotated(-PI/2)]
		for vector in standingMoveVectors:
			vector = vector.snapped(Vector2(1, 1))
			if can_move(vector) || can_take_teamless(vector):
				validMoves.append(vector)
	#flat find moves
	else:
		for vector in flatMoveVectors:
			if can_move(vector):
				validMoves.append(vector)
	return validMoves
	

func move(movePosition):
	var moveVector = movePosition - boardPosition
	
	if moveVector == facingVector || moveVector == (facingVector * -1):
		velocity = moveVector
		return
	#if standing up, set facing vector
	if facingVector == Vector2(0, 0):
		facingVector = moveVector.rotated(PI/2)
		facingVector = facingVector.snapped(Vector2(1, 1))
	else:
		facingVector = Vector2(0, 0)
	print(facingVector)
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
	queue_free()
