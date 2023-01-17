extends Position3D

signal game_setup

var newHat = preload("res://pieces/scenes/Hat.tscn")
var newFrog = preload("res://pieces/scenes/Frog.tscn")
var newBishop = preload("res://pieces/scenes/Bishop.tscn")
var newRock = preload("res://pieces/scenes/Rock.tscn")
var newSorcerer = preload("res://pieces/scenes/Sorcerer.tscn")
var newChangeling = preload("res://pieces/scenes/Changeling.tscn")
var newWheel = preload("res://pieces/scenes/Wheel.tscn")
var newPawn = preload("res://pieces/scenes/Pawn.tscn")

var newHighlight = preload("res://scenes/Highlight.tscn")
var newAI = preload("res://scenes/EnemyAI.tscn")
var newPlayer = preload("res://scenes/Player.tscn")




onready var pieceParent = get_node("PieceParent")
onready var dialogue = get_node("/root/Main/opponent")

var turnNumber = 0
var currentTurn
var teams = ["white", "black"]
var whitePlayer
var blackPlayer

var selectedPiece = null

func setup_game():
	setup_pieces()
	
	#instance an ai for black team
	whitePlayer = newPlayer.instance()
	whitePlayer.team = "white"
	add_child(whitePlayer)
	
	blackPlayer = newAI.instance()
	blackPlayer.team = "black"
	blackPlayer.enemyDirection = 1
	add_child(blackPlayer)
	
	blackPlayer.opponent = whitePlayer
	whitePlayer.opponent = blackPlayer
	
	emit_signal("game_setup")

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

