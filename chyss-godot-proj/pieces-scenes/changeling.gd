extends "res://piece-outline.gd"

#transforms into a random piece at the start of its turn
#only inherits findMoves, no other properties translate

var newHat = preload("res://pieces-scenes/Hat.tscn")
var newFrog = preload("res://pieces-scenes/Frog.tscn")
var newBishop = preload("res://pieces-scenes/Bishop.tscn")
#var newPawn = preload("res://Pawn.tscn")
#var newWheel = preload("res://Wheel.tscn")
var newSorcerer = preload("res://pieces-scenes/Sorcerer.tscn")
var newRock = preload("res://pieces-scenes/Rock.tscn")

#list of the pieces to pick a random one from
var piecesArray = [newHat, newFrog, newBishop, newSorcerer, newRock]

var childPiece = null

#on ready get a new child
func _ready():
	new_child_piece()

#on next turn if its your turn get a new child
func next_turn():
	if board.currentTurn == team:
		new_child_piece()

#find moves as the child piece
func find_moves():
	var validMoves = childPiece.find_moves()
	return validMoves


#function to get a new child piece
func new_child_piece():
	if childPiece:
		remove_child(childPiece)
	
	#get random piece
	var piece = piecesArray[randi() % piecesArray.size()].instance()
	
	#set properties and add it
	piece.boardPosition = self.boardPosition
	piece.team = self.team
	piece.board = board
	piece.highlightParent = highlightParent
	
	add_child(piece)
	#the child piece will try positioning itself relative to changeling, 
	#so we force its real translation to 0 without changing its boardPosition:
	piece.translation = Vector3(0,0,0) #has to be after add_child()
	mesh = piece.mesh
	childPiece = piece

