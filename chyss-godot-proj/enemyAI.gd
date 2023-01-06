extends Spatial

onready var board = get_parent()
onready var pieceParent = board.get_node("PieceParent")
onready var thinkTimer = get_node("ThinkTimer")
var team
var enemyDirection

class ScoreSorter:
	static func sort_by_score(a, b):
		if a.score < b.score:
			return true
		return false

func next_turn():
	if board.currentTurn == self.team:
		thinkTimer.start()

func _on_ThinkTimer_timeout():
	play_turn()
func play_turn():
	var movesArray = find_moves("friendly")
	score_moves(movesArray)
	var move = pick_move(movesArray)
	#move the piece
	move.piece.move(move.vector, true)

func find_moves(findingTeam):
	var movesArray = []
	#find all the moves
	for piece in pieceParent.get_children():
		#if they're not on our team and we're looking for friendly moves
		if piece.team != self.team && findingTeam == "friendly":
			continue
		
		#if they are on our team and we're looking for enemy moves
		if piece.team == self.team && findingTeam == "enemy":
			continue
		
		#store the piece's moves
		for move in piece.find_moves():
			var storeMove = {piece = piece, vector = move, score = 0}
			movesArray.append(storeMove)
	
	return movesArray

func score_moves(movesArray):
	#scoring algorithm:
	#+score of taking enemy piece if there is one
	#-score of current piece if it is put into danger
	
	for move in movesArray:
		var movePosition = move.piece.boardPosition + move.vector
		
		#+1 for each move towards enemy (positive y)
		move.score += move.vector.y * enemyDirection
		
		#score based on if capture
		var capture = board.find_piece(movePosition)
		if capture:
			if capture.team != self.team:
				move.score += capture.scoreValue
			else:
				move.score -= capture.scoreValue
		
		#subtract score if dangerous
		var enemyMoves = find_moves("emeny")
		for enemyMove in enemyMoves:
			var enemyMovePosition = enemyMove.vector + enemyMove.piece.boardPosition
			if enemyMovePosition == movePosition:
				move.score -= move.piece.scoreValue

func pick_move(movesArray):
	movesArray.sort_custom(ScoreSorter, "sort_by_score")
	var move = movesArray[movesArray.size() - 1 - randi() % 5]
	return move


