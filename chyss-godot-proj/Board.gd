extends Area

var newHat = preload("res://pieces-scenes/hat.tscn")
var newHighlight = preload("res://highlight.tscn")
var newFrog = preload("res://pieces-scenes/frog.tscn")
var newBishop = preload("res://pieces-scenes/bishop.tscn")

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
	var piece = newBishop.instance()
	piece.boardPosition = Vector2(3, 4)
	piece.team = "white"
	pieceParent.add_child(piece)
	piece = newBishop.instance()
	piece.boardPosition = Vector2(2, 7)
	piece.team = "black"
	pieceParent.add_child(piece)

#function to return contents of a board position
func positionContents(target):
	if outOfBounds(target):
		return("out")
	if isWhite(target):
		return("white")
	if isBlack(target):
		return("black")
	return("empty")

#bool functions for positionContents
func outOfBounds(target):
	if target.y > 7 || target.y < 0 || target.x > 7 || target.x < 0:
		return true
func isWhite(target):
	for piece in pieceParent.get_children():
		if piece.boardPosition == target && piece.team == "white":
			return true
func isBlack(target):
	for piece in pieceParent.get_children():
		if piece.boardPosition == target && piece.team == "black":
			return true

#function to find a piece at a given position
func findPiece(target):
	for piece in pieceParent.get_children():
		if piece.boardPosition == target:
			return piece

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



func getClicked():
	unselect()
