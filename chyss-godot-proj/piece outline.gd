extends Spatial

var changelingChild = false
var newHighlight = preload("res://highlight.tscn")
var highlightParent
onready var mesh = get_child(0)

onready var whiteTeamMaterial = load("res://white-team.material")
onready var blackTeamMaterial = load("res://black-team.material")


#setget allows a function to be called whenever team is modified
var team = null setget setTeam
var boardPosition = Vector2(0, 0)
var board

func _ready():
	updatePosition()
	getOtherNodes()

#function to get other nodes on ready
func getOtherNodes():
	if changelingChild:
		board = get_parent().get_parent().get_parent()
	else:
		board = get_parent().get_parent()
		highlightParent = get_node("HighlightParent")

#function for when the piece is clicked
func _on_TextureButton_button_down():
	getClicked()
func getClicked():
	if team == board.currentTurn:
		board.unselect()
		var validMoves = findMoves()
		spawnHighlights(validMoves)
		board.selectedPiece = self
	
	#weird check if there's a highlight under me
	elif board.selectedPiece:
		for highlight in board.selectedPiece.highlightParent.get_children():
			if (board.selectedPiece.boardPosition + highlight.boardPosition) == boardPosition:
				highlight.getClicked()
				return

#function to find the pieces movess
func findMoves():
	var validMoves = []
	return validMoves

#return true if a space is valid and empty
func canMove(target):
	if board.outOfBounds(boardPosition + target):
		return false
	if board.findPiece(boardPosition + target):
		return false
	return true

#return true if a space is valid and has an enemy
func canTake(target):
	if board.outOfBounds(boardPosition + target):
		return false
	var targetPiece = board.findPiece(boardPosition + target)
	if targetPiece:
		if targetPiece.team != team:
			return true

#function to show highlights at each valid move
func spawnHighlights(validMoves):
	if validMoves:
		for move in validMoves:
			var highlight = newHighlight.instance()
			highlight.boardPosition = move
			highlightParent.add_child(highlight)

#function to move when a highlight is clicked
func move(moveVector, nextTurn):
	#look for a piece to capture
	var capturePiece = board.findPiece(boardPosition+moveVector)
	if capturePiece:
		if capturePiece != self:
			capturePiece.getCaptured()
	
	#move self
	boardPosition += moveVector
	updatePosition()
	
	#change turn
	if nextTurn:
		board.nextTurn()

#function to make a random move
func randomMove():
	var validMoves = findMoves()
	var randomChoice = randi() % validMoves.size()
	move(validMoves[randomChoice], false)
#function to get captured
func getCaptured():
	queue_free()
#function to update piece position
func updatePosition():
	var tmp = (boardPosition * 1/8)
	translation = Vector3(tmp.x, 0, tmp.y)

func nextTurn():
	pass


#i am isaiah adding these functions:

#function to change the piece's material to match its team
func setTeam(newTeam):
	team = newTeam #value gets set
	#set material based on team
	if team == "white":
		mesh.material_override = whiteTeamMaterial 
	elif team == "black":
		mesh.material_override = blackTeamMaterial
