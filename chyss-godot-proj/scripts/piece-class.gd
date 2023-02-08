class_name piece extends Spatial

#Base class for all pieces

#signals
signal animation_finished
#other nodes
var pieceParent = null
onready var mesh = get_child(0)
#material preloads
onready var whiteTeamMaterial = load("res://materials/white-team.material")
onready var blackTeamMaterial = load("res://materials/black-team.material")
#normal map texture, can be set by a subclass or left as null
#to set normal map, assign the var to the path to an image.
var normalMap = null setget set_normal_map

#piece parameters
#setget allows a function to be called whenever team is modified (include self.)
var boardPosition = null setget update_position
var team = null setget set_team
var jailed = false
var scoreValue = 0
var scoreArray = [
					{type = "Bishop", score = 5},
					{type = "Changeling", score = 5},
					{type = "Frog", score = 10},
					{type = "Hat", score = 7},
					{type = "Pawn", score = 2},
					{type = "Rock", score = 999},
					{type = "Sorcerer", score = 5},
					{type = "Wheel", score = 7},
					{type = "Checker", score = 100000}
														]
var model_offset = Vector3(0,0,0)

func _ready():
	#some pieces are passed in pieceParent, so they dont do this
	if !pieceParent:
		pieceParent = get_parent()
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

#function to find the pieces moves OVERLOAD THIS
func find_moves():
	var validMoves = []
	return validMoves

#return true if space a passed position is valid and empty
func can_move(position):
	if pieceParent.out_of_bounds(position):
		return false
	if pieceParent.find_piece(position):
		return false
	return true

#return true if a space a passed in vector away is valid and has an enemy
func can_take(position):
	if pieceParent.out_of_bounds(position):
		return false
	var targetPiece = pieceParent.find_piece(position)
	if targetPiece:
		if targetPiece.team != team:
			return true

#returns true if a space is valid and has any piece
func can_take_teamless(position):
	if pieceParent.out_of_bounds(position):
		return false
	var targetPiece = pieceParent.find_piece(position)
	if targetPiece:
		return true

#function to move to a given position
func move(movePosition):
	self.boardPosition = movePosition

#function to make a random move
func random_move():
	var validMoves = find_moves()
	var randomChoice = randi() % validMoves.size()
	var move = validMoves[randomChoice]
	move(move.vectors[-1])
	if move.captures && move.captures[0] != null:
		for capture in move.captures:
			capture.get_captured()
#function to get captured
func get_captured():
	individual_get_captured()
	pieceParent.remove_child(self)
	queue_free()
func individual_get_captured():
	pass
#function to update piece position
func update_position(newPosition):
	boardPosition = newPosition
	var tmp = (boardPosition * 1/8)
	individual_set_position()
	#fancy saves the rest for entering scene tree
	if not is_inside_tree():
		yield(self, "ready")
		translation = Vector3(tmp.x, 0, tmp.y) + model_offset
	else:
		translate_tweened(Vector3(tmp.x, 0, tmp.y))
func individual_set_position():
	pass

#function to handle tween animation of pieces moving
func translate_tweened(newPosition):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "translation:y", .1, .5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "translation:y", newPosition.y, .5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween = get_tree().create_tween().set_parallel(true)
	tween.parallel().tween_property(self, "translation:x", newPosition.x, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "translation:z", newPosition.z, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	yield(tween, "finished")
	emit_signal("animation_finished")

#function called at the start of every turn
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
		mesh.material_override = whiteTeamMaterial.duplicate()
	elif team == "black":
		mesh.material_override = blackTeamMaterial.duplicate()
	set_normal_map(normalMap)
	individual_set_team()
#function for individual pieces to react to their team being set
func individual_set_team():
	pass

#normalMap setget
func set_normal_map(pathToMap):
	normalMap = pathToMap #actually set the variable (should be a string)
	#yield until we're in the tree
	if not is_inside_tree():
		yield(self, "ready")
	if normalMap: #path could be null, meaning no normal map
		mesh.material_override.normal_texture = load(pathToMap) 
	else:
		mesh.material_override.normal_texture = null
