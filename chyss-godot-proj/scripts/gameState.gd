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

onready var board = get_node("/root/Main/chyss table bits/Board")
var pieceParent

#function to start the board being set up
func _ready():
	randomize()
	yield(board, "ready")
	pieceParent = board.pieceParent
	board.setup_game()
	run_game()

#main loop that runs the game
func run_game():
	while !is_game_lost():
		#queue the dialogue
		board.pieceParent.tell_pieces_turn(turn)
		Dialogue.append_queue(["turnNumber"], [turnNumber])
		Dialogue.queue_dialogue()
		#play dialogue, yield until finished
		if Dialogue.dialogueQueue.size() > 0:
			Dialogue.play_queue()
			print("yielding until all_dialogue_finished")
			yield (Dialogue, "all_dialogue_finished")
		#start the turn, yield until finished
		if turn == "white":
			board.whitePlayer.play_turn()
		else:
			board.blackPlayer.play_turn()
		print("yielding until move_made")
		yield (board, "move_made")
		Sfx.play_badunk(randf())
		#increment the turn number, toggle whose turn it is
		turnNumber += 1
		toggle_turn()
	Dialogue.append_queue(["loser"], [identify_loser()])
	Dialogue.queue_dialogue()
	Dialogue.play_queue()
	print("yielding until all_dialogue_finished")
	yield (Dialogue, "all_dialogue_finished")
	
	DialogueManager.show_balloon("again_query", Dialogue.dialogue)

#toggles which teams turn it is
func toggle_turn():
	if turn == "white":
		turn = "black"
	else:
		turn = "white"
#checks if a player has lost
func is_game_lost():
	var whiteLost = true
	var blackLost = true
	#check if teams have their checkers
	for piece in pieceParent.get_children():
		if piece.type == "Checker":
			if piece.team == "white":
				whiteLost = false
			if piece.team == "black":
				blackLost = false
	
	return (whiteLost || blackLost)
#returns who lost
func identify_loser():
	var whiteLost = true
	var blackLost = true
	#check if teams have their checkers
	for piece in pieceParent.get_children():
		if piece.type == "Checker":
			if piece.team == "white":
				whiteLost = false
			if piece.team == "black":
				blackLost = false
	if whiteLost && blackLost:
		return "draw"
	if whiteLost:
		return "white"
	return "black"
#function to restart the game
func reset_game():
	turn = "white"
	board.clear_game()
	board.setup_game()
	board.blackPlayer.jailedPiece = null
	
	run_game()
