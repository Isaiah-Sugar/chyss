extends Spatial

var changelingChild = false
var newHighlight = preload("res://Highlight.tscn")
var highlightParent
onready var mesh = get_child(0)

onready var whiteTeamMaterial = load("res://white-team.material")
onready var blackTeamMaterial = load("res://black-team.material")


#setget allows a function to be called whenever team is modified
var team = null setget set_team
var boardPosition = Vector2(0, 0)
var board

func _ready():
	update_position()
	get_other_nodes()

#function to get other nodes on ready
func get_other_nodes():
	if changelingChild:
		board = get_parent().get_parent().get_parent()
	else:
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
	
	#move self
	boardPosition += moveVector
	update_position()
	
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
func update_position():
	var tmp = (boardPosition * 1/8)
	translation = Vector3(tmp.x, 0, tmp.y)

func next_turn():
	pass


#i am isaiah adding these functions:

#function to change the piece's material to match its team
func set_team(newTeam):
	team = newTeam #value gets set
	#set material based on team
	if team == "white":
		mesh.material_override = whiteTeamMaterial 
	elif team == "black":
		mesh.material_override = blackTeamMaterial
