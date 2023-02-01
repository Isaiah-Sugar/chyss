extends Position3D

#Parent of everything on the board, instances all the pieces, and instances players as children of itself
#signals to main
signal game_setup
signal move_made
#preloads of every piece
var newHat = preload("res://pieces/scenes/Hat.tscn")
var newFrog = preload("res://pieces/scenes/Frog.tscn")
var newBishop = preload("res://pieces/scenes/Bishop.tscn")
var newRock = preload("res://pieces/scenes/Rock.tscn")
var newSorcerer = preload("res://pieces/scenes/Sorcerer.tscn")
var newChangeling = preload("res://pieces/scenes/Changeling.tscn")
var newWheel = preload("res://pieces/scenes/Wheel.tscn")
var newPawn = preload("res://pieces/scenes/Pawn.tscn")
var newChecker = preload("res://pieces/scenes/Checker.tscn")

#preloads of players
var newAI = preload("res://scenes/EnemyAI.tscn")
var newPlayer = preload("res://scenes/Player.tscn")

#other nodes
onready var pieceParent = get_node("PieceParent")
var whitePlayer
var blackPlayer

#board parameters
var teams = ["white", "black"]

#function to set up the game, instances pieces and players
func setup_game():
	#instance all the pieces
	setup_pieces()
	#instance_piece(newChecker, Vector2(3, 5), teams[0])
	#instance_piece(newPawn, Vector2(4, 4), teams[1])
	
	#instance player for white team
	whitePlayer = newPlayer.instance()
	whitePlayer.team = "white"
	add_child(whitePlayer)
	
	#instance an ai for black team
	blackPlayer = newAI.instance()
	blackPlayer.team = "black"
	blackPlayer.enemyDirection = 1
	add_child(blackPlayer)
	
	blackPlayer.opponent = whitePlayer
	whitePlayer.opponent = blackPlayer
	#signal main that its done
	emit_signal("game_setup")

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

#function to instance an individual piece
func instance_piece(type, boardPosition, team):
	var piece = type.instance()
	piece.boardPosition = boardPosition
	piece.team = team
	pieceParent.add_child(piece)
