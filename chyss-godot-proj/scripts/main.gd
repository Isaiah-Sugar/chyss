#long term
#more/better guy animations, lighter guy rig
#lock to specitic camera angles?

#scripts to update
	#board
	#players
	#dialogue

extends Spatial

#team stores whose turn it is
var turn = "white"
var turnCount = 0

onready var dialogue = get_node("opponent")
onready var board = get_node("chyss table bits/Board")

#function to start the board being set up
func _ready():
	randomize()
	board.connect("game_setup", self, "_on_game_setup")
	board.setup_game()

#once the board is set up, queue dialogue
func _on_game_setup():
	connect_signals()
	board.pieceParent.tell_pieces_turn(turn)
	dialogue.queue_dialogue({vector = null}, turnCount)

func connect_signals():
	dialogue.connect("dialogue_finished", self, "_on_dialogue_finished")
	board.whitePlayer.connect("move_made", self, "_on_move_made")
	board.blackPlayer.connect("move_made", self, "_on_move_made")

#when the dialogue is finished, tell the turn player to play their turn
func _on_dialogue_finished():
	if turn == "white":
		board.whitePlayer.play_turn()
	else:
		board.blackPlayer.play_turn()

func _on_move_made(move):
	toggle_turn()
	board.pieceParent.tell_pieces_turn(turn)
	dialogue.queue_dialogue(move, turnCount)
	
func toggle_turn():
	if turn == "white":
		turn = "black"
	else:
		turn = "white"
