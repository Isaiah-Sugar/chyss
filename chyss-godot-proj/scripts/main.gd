#long term
#more/better guy animations, lighter guy rig
#lock to specitic camera angles?
#checker animation
#more dialogue

extends Spatial

#team stores whose turn it is
var turn = "white"
var turnNumber = 0
var gameRunning

onready var board = get_node("chyss table bits/Board")

#function to start the board being set up
func _ready():
	randomize()
	board.connect("game_setup", self, "_on_game_setup")
	board.setup_game()

#once the board is set up, queue dialogue
func _on_game_setup():
	gameRunning = true
	run_game()


func run_game():
	while gameRunning == true:
		board.pieceParent.tell_pieces_turn(turn)
		Dialogue.append_queue(["turnNumber"], [turnNumber])
		Dialogue.queue_dialogue()
		
		if Dialogue.dialogueQueue.size() > 0:
			Dialogue.play_queue()
			yield (Dialogue, "dialogue_finished")
		
		if turn == "white":
			board.whitePlayer.play_turn()
		else:
			board.blackPlayer.play_turn()
		
		yield (board, "move_made")
		
		turnNumber += 1
		toggle_turn()

func toggle_turn():
	if turn == "white":
		turn = "black"
	else:
		turn = "white"
