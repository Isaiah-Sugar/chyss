#long term
#more/better guy animations, lighter guy rig
#lock to specitic camera angles?
#checker animation
#more dialogue

extends Spatial

#script to handle the main game state, runs a big ol while loop for everything

#team stores whose turn it is
var turn = "white"
var turnNumber = 0
var gameRunning

onready var board = get_node("chyss table bits/Board")

#function to start the board being set up
func _ready():
	randomize()
	board.setup_game()
	gameRunning = true
	run_game()

#main loop that runs the game
func run_game():
	while gameRunning == true:
		#queue the dialogue
		board.pieceParent.tell_pieces_turn(turn)
		Dialogue.append_queue(["turnNumber"], [turnNumber])
		Dialogue.queue_dialogue()
		#play dialogue, yield until finished
		if Dialogue.dialogueQueue.size() > 0:
			Dialogue.play_queue()
			yield (Dialogue, "all_dialogue_finished")
		#start the turn, yield until finished
		if turn == "white":
			board.whitePlayer.play_turn()
		else:
			board.blackPlayer.play_turn()
		yield (board, "move_made")
		#increment the turn number, toggle whose turn it is
		turnNumber += 1
		toggle_turn()

#toggles which teams turn it is
func toggle_turn():
	if turn == "white":
		turn = "black"
	else:
		turn = "white"
