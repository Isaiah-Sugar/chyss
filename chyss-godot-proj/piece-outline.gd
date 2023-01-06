class_name piece extends Spatial


var board = null
var highlightParent
onready var mesh = get_child(0)

var newHighlight = preload("res://Highlight.tscn")
onready var whiteTeamMaterial = load("res://white-team.material")
onready var blackTeamMaterial = load("res://black-team.material")

#setget allows a function to be called whenever team is modified (include self.)
var boardPosition = null setget update_position
var team = null setget set_team

func _ready():
	if !board:
	  get_other_nodes()
	individual_ready()
#function for when a piece needs to do things on ready
func individual_ready():
	pass

#function to get other nodes on ready
func get_other_nodes():
	board = get_parent().get_parent()
	highlightParent = get_node("HighlightParent")

#function for when the piece is clicked
func get_clicked():
	if team == board.currentTurn:
		board.unselect()
		var validMoves = find_moves()
		spawn_highlights(validMoves)
		board.selectedPiece = self
	
	#weird check if there's a highlight under me
	elif board.selectedPiece:
		for highlight in board.selectedPiece.highlightParent.get_children():
			if (board.selectedPiece.boardPosition + highlight.boardPosition) == boardPosition:
				highlight.get_clicked()
				return

#function to find the pieces movess
func find_moves():
	var validMoves = []
	return validMoves

#return true if a space is valid and empty
func can_move(target):
	if board.out_of_bounds(boardPosition + target):
		return false
	if board.find_piece(boardPosition + target):
		return false
	return true

#return true if a space is valid and has an enemy
func can_take(target):
	if board.out_of_bounds(boardPosition + target):
		return false
	var targetPiece = board.find_piece(boardPosition + target)
	if targetPiece:
		if targetPiece.team != team:
			return true

#function to show highlights at each valid move
func spawn_highlights(validMoves):
	if validMoves:
		for move in validMoves:
			var highlight = newHighlight.instance()
			highlight.boardPosition = move
			highlightParent.add_child(highlight)

#function to move when a highlight is clicked
func move(moveVector, nextTurn):
	#look for a piece to capture
	var capturePiece = board.find_piece(boardPosition+moveVector)
	if capturePiece:
		if capturePiece != self:
			capturePiece.get_captured()
	
	#must say self for setget to work
	self.boardPosition += moveVector
	#change turn
	if nextTurn:
		board.next_turn()

#function to make a random move
func random_move():
	var validMoves = find_moves()
	var randomChoice = randi() % validMoves.size()
	move(validMoves[randomChoice], false)
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
		translation = Vector3(tmp.x, 0, tmp.y)
	
	translate_tweened(Vector3(tmp.x, 0, tmp.y))

func translate_tweened(newPosition):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "translation", newPosition, 1)


func next_turn():
	pass


#i am isaiah adding these functions:

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
