extends "res://piece outline.gd"

#transforms into a random piece at the start of its turn
#only inherits findMoves, no other properties translate

var newHat = preload("res://pieces-scenes/hat.tscn")
var newFrog = preload("res://pieces-scenes/frog.tscn")
var newBishop = preload("res://pieces-scenes/bishop.tscn")
#var newPawn = preload("res://Pawn.tscn")
#var newWheel = preload("res://Wheel.tscn")
var newSorcerer = preload("res://pieces-scenes/sorcerer.tscn")
var newRock = preload("res://pieces-scenes/rock.tscn")

#list of the pieces to pick a random one from
var piecesArray = [newHat, newFrog, newBishop, newSorcerer, newRock]

var childPiece = null

#on ready get a new child
func _ready():
	newChildPiece()

#on next turn if its your turn get a new child
func nextTurn():
	if board.currentTurn == team:
		newChildPiece()

#find moves as the child piece
func findMoves():
	var validMoves = childPiece.findMoves()
	return validMoves


#function to get a new child piece
func newChildPiece():
	if childPiece:
		remove_child(childPiece)
	
	#get random piece
	var piece = piecesArray[randi() % piecesArray.size()].instance()
#	piece.visible = false
	
	#set properties and add it
	piece.boardPosition = self.boardPosition
	piece.changelingChild = true
	add_child(piece)
	piece.team = self.team
	childPiece = piece
