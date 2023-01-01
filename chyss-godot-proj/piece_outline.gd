extends Spatial

var changelingChild = false
var newHighlight = preload("res://highlight.tscn")
onready var highlightParent = get_node("HighlightParent")
onready var mesh = get_child(0)

onready var whiteTeamMaterial = load("res://white-team.material")
onready var blackTeamMaterial = load("res://black-team.material")


#setget allows a function to be called whenever team is modified
var team = null setget setTeam
var boardPosition = Vector2(0, 0)
var moveVectors = []
onready var board = get_parent().get_parent()

func _ready():
	updatePosition()
#function for when the piece is clicked
func _on_TextureButton_button_down():
	getClicked()
func getClicked():
	if team == board.currentTurn:
		board.unselect()
		var validMoves = findMoves()
		spawnHighlights(validMoves)
		board.selectedPiece = self
	elif board.selectedPiece:
		
		for highlight in board.selectedPiece.highlightParent.get_children():
			print(boardPosition)
			if (board.selectedPiece.boardPosition + highlight.boardPosition) == boardPosition:
				highlight.getClicked()
				return

#function to find the pieces movess
func findMoves():
	var validMoves = []
	return validMoves

#function to show highlights at each valid move
func spawnHighlights(validMoves):
	for move in validMoves:
		var highlight = newHighlight.instance()
		highlight.boardPosition = move
		highlightParent.add_child(highlight)

#function to move when a highlight is clicked
func move(moveVector, nextTurn):
	if board.positionContents(boardPosition+moveVector) != "empty":
		var capture = board.findPiece(boardPosition+moveVector)
		capture.getCaptured()
	boardPosition += moveVector
	updatePosition()
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



#i am isaiah adding these functions:
func setTeam(newTeam):
	team = newTeam #value gets set
	#set material based on team
	if team == "white":
		mesh.material_override = whiteTeamMaterial 
	elif team == "black":
		mesh.material_override = blackTeamMaterial
