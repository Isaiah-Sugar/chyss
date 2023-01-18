class_name piece extends Spatial


var pieceParent = null
onready var mesh = get_child(0)

onready var whiteTeamMaterial = load("res://materials/white-team.material")
onready var blackTeamMaterial = load("res://materials/black-team.material")

#setget allows a function to be called whenever team is modified (include self.)
var boardPosition = null setget update_position
var team = null setget set_team
var scoreValue = 0
var scoreArray = [
					{type = "Bishop", score = 5},
					{type = "Changeling", score = 5},
					{type = "Frog", score = 10},
					{type = "Hat", score = 7},
					{type = "Pawn", score = 2},
					{type = "Rock", score = 1000},
					{type = "Sorcerer", score = 5},
					{type = "Wheel", score = 7},
														]

var model_offset = Vector3(0,0,0)

func _ready():
	if !pieceParent:
	  get_other_nodes()
	get_score()
	individual_ready()

#function to get piece's score value
func get_score():
	for pieceScore in scoreArray:
		if pieceScore.type == self.type:
			scoreValue = pieceScore.score

#function for when a piece needs to do things on ready
func individual_ready():
	pass

#function to get other nodes on ready
func get_other_nodes():
	pieceParent = get_parent()

#function to find the pieces movess
func find_moves():
	var validMoves = []
	return validMoves

#return true if a space is valid and empty
func can_move(target):
	if pieceParent.out_of_bounds(boardPosition + target):
		return false
	if pieceParent.find_piece(boardPosition + target):
		return false
	return true

#return true if a space is valid and has an enemy
func can_take(target):
	if pieceParent.out_of_bounds(boardPosition + target):
		return false
	var targetPiece = pieceParent.find_piece(boardPosition + target)
	if targetPiece:
		if targetPiece.team != team:
			return true

#returns true if a space is valid and has any piece
func can_take_teamless(target):
	if pieceParent.out_of_bounds(boardPosition + target):
		return false
	var targetPiece = pieceParent.find_piece(boardPosition + target)
	if targetPiece:
		return true

#function to move to a given position
func move(movePosition):
	#look for a piece to capture
	var capturePiece = pieceParent.find_piece(movePosition)
	#must say self for setget to work
	self.boardPosition = movePosition
	#capture piece after moving, so that it knows your position when this runs
	if capturePiece:
		if capturePiece != self:
			capturePiece.get_captured()

#function to make a random move
func random_move():
	var validMoves = find_moves()
	var randomChoice = randi() % validMoves.size()
	move(validMoves[randomChoice] + boardPosition)
#function to get captured
func get_captured():
	queue_free()
#function to update piece position
func update_position(newPosition):
	boardPosition = newPosition
	var tmp = (boardPosition * 1/8)
	
	#fancy saves the rest for entering scene tree
	if not is_inside_tree():
		yield(self, "ready")
		print(str(self) + str(model_offset))
		translation = Vector3(tmp.x, 0, tmp.y) + model_offset
	else:
		translate_tweened(Vector3(tmp.x, 0, tmp.y))
		

func translate_tweened(newPosition):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "translation:y", .1, .5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "translation:y", newPosition.y, .5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween = get_tree().create_tween()
	tween.tween_property(self, "translation:x", newPosition.x, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween = get_tree().create_tween()
	tween.tween_property(self, "translation:z", newPosition.z, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	

func next_turn(_currentTurn):
	pass

#function to change the piece's material to match its team
func set_team(newTeam):
	team = newTeam #value gets set
	
	#fancy saves the rest for entering scene tree
	if not is_inside_tree():
		yield(self, "ready")
	
	#set material based on team
	if team == "white":
		mesh.material_override = whiteTeamMaterial 
	elif team == "black":
		mesh.material_override = blackTeamMaterial
	individual_set_team()
#function for individual pieces to react to their team being set
func individual_set_team():
	pass
