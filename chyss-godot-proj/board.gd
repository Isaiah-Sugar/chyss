extends Area

var newHat = preload("res://pieces-scenes/Hat.tscn")
var newFrog = preload("res://pieces-scenes/Frog.tscn")
var newBishop = preload("res://pieces-scenes/Bishop.tscn")
var newRock = preload("res://pieces-scenes/Rock.tscn")
var newSorcerer = preload("res://pieces-scenes/Sorcerer.tscn")
var newChangeling = preload("res://pieces-scenes/Changeling.tscn")

var newHighlight = preload("res://Highlight.tscn")


onready var pieceParent = get_node("PieceParent")

var currentTurn = "white"
var teams = ["white", "black"]

var selectedPiece = null

##if a click is not on a button, unselect
#func _unhandled_input(event):
#	if event.is_action_pressed("left click"):
#		unselect()

func _ready():
	randomize()
	
	instancePiece(newBishop, Vector2(1,1), teams[0])
	instancePiece(newBishop, Vector2(5,3), teams[1])
	instancePiece(newHat, Vector2(7,6), teams[0])
	instancePiece(newFrog, Vector2(3,4), teams[1])
	instancePiece(newRock, Vector2(3,2), teams[0])
	instancePiece(newSorcerer, Vector2(4,6), teams[1])
	instancePiece(newChangeling, Vector2(5,5), teams[1])

func instancePiece(type, boardPosition, team):
	var piece = type.instance()
	piece.boardPosition = boardPosition
	pieceParent.add_child(piece)
	piece.team = team

#bool functions to return if a position is out of bounds
func outOfBounds(target):
	if target.y > 7 || target.y < 0 || target.x > 7 || target.x < 0:
		return true

#function to find a piece at a given position
func findPiece(target):
	for piece in pieceParent.get_children():
		if piece.boardPosition == target:
			return piece
	return null

#function to unselect the current piece (remove all highlights)
func unselect():
	selectedPiece = null
	for piece in pieceParent.get_children():
		for highlight in piece.highlightParent.get_children():
			piece.highlightParent.remove_child(highlight)
			highlight.queue_free()

#function to progress to the next turn
func nextTurn():
	unselect()
	var teamIndex = teams.find(currentTurn)
	teamIndex += 1
	if teamIndex == teams.size():
		teamIndex = 0
	currentTurn = teams[teamIndex]
	for piece in pieceParent.get_children():
		piece.nextTurn()



func getClicked():
	unselect()
