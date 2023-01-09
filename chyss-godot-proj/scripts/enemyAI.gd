extends Spatial

onready var board = get_parent()
onready var pieceParent = board.get_node("PieceParent")
onready var thinkTimer = get_node("ThinkTimer")
var team
var enemyDirection
#enemies to ignore in danger finding (have spaces they dont capture, or movement cannot be predicted)
var ignoredEnemies = ["Pawn", "Sorcerer", "Changeling"]

#fancy custom sorter
class ScoreSorter:
	static func sort_by_score(a, b):
		if a.score < b.score:
			return true
		return false

#called by board, starts turn if its AI's turn
func next_turn():
	if board.currentTurn == self.team:
		thinkTimer.start()

func _on_ThinkTimer_timeout():
	play_turn()
#function to play the ai's turn
func play_turn():
	var movesArray = find_moves("friendly")
	var dangerArray = find_danger()
	score_moves(movesArray, dangerArray)
	var move = pick_move(movesArray)
	#move the piece
	move.piece.move(move.vector+move.piece.boardPosition, true)
#function to find all the moves a team can make
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
#function to find dangerous tiles
func find_danger():
	var dangerArray = []
	for move in find_moves("enemy"):
		#ignore pawns because cant capture forward, ignore changeling because cant know
		if ignoredEnemies.find(move.piece.type) == -1:
			dangerArray.append(move.vector + move.piece.boardPosition)
	return dangerArray
#function to score an array of moves
func score_moves(movesArray, dangerArray):
	#scoring algorithm:
	#+score of taking enemy piece if there is one
	#-score of current piece if it is put into danger
	#+score of current piece if it moves out of danger
	for move in movesArray:
		var movePosition = move.piece.boardPosition + move.vector
		
		#+1 for each move towards enemy (positive y)
		move.score += (move.vector.y * enemyDirection)/8
		
		#score based on if capture
		var capture = board.find_piece(movePosition)
		if capture:
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

#function to pick a move from the array
func pick_move(movesArray):
	#sort
	movesArray.sort_custom(ScoreSorter, "sort_by_score")
	
	#remove moves that score too low (5 less than the highest score)
	var i = movesArray.size()
	while i > 0:
		i -= 1
		if movesArray[-1].score - movesArray[i].score >= 3:
			movesArray.pop_at(i)
	
	print("New turn:")
	for move in movesArray:
		print(move, move.piece.boardPosition)
	
	var move = movesArray[randi() % movesArray.size()]
	return move


