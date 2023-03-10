class_name Player extends Spatial

#base class for all players, one is instanced for each team. they determine the moves made on their turns

#other nodes
var opponent
onready var board = get_parent()
onready var pieceParent = board.get_node("PieceParent")

#player parameters
var enemyDirection
var team
#enemies to ignore in danger finding (have spaces they dont capture, or movement cannot be predicted)
var ignoredEnemies = ["Pawn", "Sorcerer", "Changeling"]

#function to find all the moves self can make
func find_moves():
	var movesArray = []
	#find all the moves
	for piece in pieceParent.get_children():
		#if they're not on our team continue
		if piece.team != self.team:
			continue
		if piece.jailed == true:
			continue
		#store the piece's moves
		movesArray.append_array(piece.find_moves())
	return movesArray
#function to make a move
func make_move(move):
	#pass vars into Dialogue
	Dialogue.append_queue(["movePiece", "moveCaptures", "moveScore", "moveTeam"], [move.piece, move.captures, move.score, move.team])
	#loop to animate piece moving and captures happening
	var index = 0
	while (move.vectors.size() > index || move.captures.size() > index):
		if move.vectors.size() > index:
			move.piece.move(move.vectors[index])
			yield (move.piece, "animation_finished")
		if move.captures.size() > index:
			move.captures[index].get_captured()
		index += 1
	#tell main the move is made
	board.call_deferred("emit_signal", "move_made")

#old ai algorithm stuff, going to be replaced but for now there isnt a new one

#function to find dangerous tiles
func find_danger():
	var dangerArray = []
	for move in opponent.find_moves():
		#ignore pawns because cant capture forward, ignore changeling because cant know
		if ignoredEnemies.find(move.piece.type) == -1:
			dangerArray.append(move.vectors[-1])
	return dangerArray
#function to score an array of moves
func score_move(move, dangerArray):
	#scoring algorithm:
	#+score of taking enemy piece if there is one
	#-score of current piece if it is put into danger
	#+score of current piece if it moves out of danger
	var movePosition = move.vectors[-1]
	
	if move.captures.size() > 0:
		for capture in move.captures:
			if capture.team != self.team:
				move.score += capture.scoreValue
			else:
				move.score -= capture.scoreValue

	#subtract score if dangerous
	if dangerArray.find(movePosition) != -1:
		move.score -= move.piece.scoreValue
	#add score if move out of danger
	if dangerArray.find(move.piece.boardPosition) != -1 && dangerArray.find(movePosition) == -1:
		move.score += move.piece.scoreValue
