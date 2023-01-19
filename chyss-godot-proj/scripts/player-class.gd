class_name Player extends Spatial

signal move_made(move)


var enemyDirection
var team
#enemies to ignore in danger finding (have spaces they dont capture, or movement cannot be predicted)
var ignoredEnemies = ["Pawn", "Sorcerer", "Changeling"]

var opponent
onready var board = get_parent()
onready var pieceParent = board.get_node("PieceParent")

#function to find all the moves a team can make
func find_moves():
	var movesArray = []
	#find all the moves
	for piece in pieceParent.get_children():
		
		#if they're not on our team continue
		if piece.team != self.team:
			continue
	
		#store the piece's moves
		movesArray.append_array(piece.find_moves())
	
	return movesArray
#function to find dangerous tiles
func find_danger():
	var dangerArray = []
	for move in opponent.find_moves():
		#ignore pawns because cant capture forward, ignore changeling because cant know
		if ignoredEnemies.find(move.piece.type) == -1:
			dangerArray.append(move.vector + move.piece.boardPosition)
	return dangerArray
#function to score an array of moves
func score_move(move, dangerArray):
	#scoring algorithm:
	#+score of taking enemy piece if there is one
	#-score of current piece if it is put into danger
	#+score of current piece if it moves out of danger
	var movePosition = move.piece.boardPosition + move.vector
	
	#+1 for each move towards enemy (positive y)
	move.score += (move.vector.y * enemyDirection)/8
	
	#score based on if capture
	var capture = pieceParent.find_piece(movePosition)
	if capture:
		move.capture = capture
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
#function to make a move
#and to tell the board its the next turn
func make_move(move):
	move.piece.move(move.vector+move.piece.boardPosition)
	if move.capture:
		move.capture.get_captured()
	
	Dialogue.append_queue(["movePiece", "moveCapture", "moveScore", "moveTeam"], [move.piece, move.capture, move.score, move.team])
	
	
	emit_signal("move_made", move)
