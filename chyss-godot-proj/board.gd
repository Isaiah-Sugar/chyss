extends Area

var newHat = preload("res://pieces-scenes/Hat.tscn")
var newFrog = preload("res://pieces-scenes/Frog.tscn")
var newBishop = preload("res://pieces-scenes/Bishop.tscn")
var newRock = preload("res://pieces-scenes/Rock.tscn")
var newSorcerer = preload("res://pieces-scenes/Sorcerer.tscn")
var newChangeling = preload("res://pieces-scenes/Changeling.tscn")
var newWheel = preload("res://pieces-scenes/Wheel.tscn")
var newPawn = preload("res://pieces-scenes/Pawn.tscn")

var newHighlight = preload("res://Highlight.tscn")
var newAI = preload("res://EnemyAI.tscn")

onready var pieceParent = get_node("PieceParent")
var enemy

var currentTurn
var teams = ["white", "black"]

var selectedPiece = null

func _ready():
	setup_pieces()
	
	#instance an ai for black team
	enemy = newAI.instance()
	enemy.team = "black"
	enemy.enemyDirection = 1
	add_child(enemy)
	
	next_turn()

func instance_piece(type, boardPosition, team):
	var piece = type.instance()
	piece.boardPosition = boardPosition
	piece.team = team
	pieceParent.add_child(piece)

#function to give each team a set of pieces
func setup_pieces():
	for piece in pieceParent.get_children():
		piece.queue_free()
	
	for n in 8:
		instance_piece(newPawn, Vector2(n, 1), teams[1])
		instance_piece(newPawn, Vector2(n, 6), teams[0])
	
	instance_piece(newSorcerer, Vector2(0, 0), teams[1])
	instance_piece(newHat, Vector2(1, 0), teams[1])
	instance_piece(newBishop, Vector2(2, 0), teams[1])
	instance_piece(newWheel, Vector2(3, 0), teams[1])
	instance_piece(newRock, Vector2(4, 0), teams[1])
	instance_piece(newBishop, Vector2(5, 0), teams[1])
	instance_piece(newHat, Vector2(6, 0), teams[1])
	instance_piece(newChangeling, Vector2(7, 0), teams[1])
	
	instance_piece(newSorcerer, Vector2(7, 7), teams[0])
	instance_piece(newHat, Vector2(6, 7), teams[0])
	instance_piece(newBishop, Vector2(5, 7), teams[0])
	instance_piece(newWheel, Vector2(4, 7), teams[0])
	instance_piece(newRock, Vector2(3, 7), teams[0])
	instance_piece(newBishop, Vector2(2, 7), teams[0])
	instance_piece(newHat, Vector2(1, 7), teams[0])
	instance_piece(newChangeling, Vector2(0, 7), teams[0])

#bool functions to return if a position is out of bounds
func out_of_bounds(target):
	if target.y > 7 || target.y < 0 || target.x > 7 || target.x < 0:
		return true

#function to find a piece at a given position
func find_piece(target):
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
func next_turn():
	unselect()
	if !currentTurn:
		#set it to the first team
		currentTurn = teams[0]
	else:
		#change the team
		var teamIndex = teams.find(currentTurn)
		teamIndex += 1
		if teamIndex == teams.size():
			teamIndex = 0
		currentTurn = teams[teamIndex]
	
	#tell all the pieces its the next turn
	for piece in pieceParent.get_children():
		piece.next_turn()
	
	enemy.next_turn()



func get_clicked():
	unselect()

