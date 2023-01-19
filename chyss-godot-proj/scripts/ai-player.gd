extends Player

onready var thinkTimer = get_node("ThinkTimer")

#fancy custom sorter
class ScoreSorter:
	static func sort_by_score(a, b):
		if a.score < b.score:
			return true
		return false

#function to play the ai's turn
func play_turn():
	thinkTimer.start()
	
	yield(thinkTimer, "timeout")
	
	var movesArray = find_moves()
	var dangerArray = find_danger()
	for move in movesArray:
		score_move(move, dangerArray)
	var move = pick_move(movesArray)
	make_move(move)
	#move the piece

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

	var move = movesArray[randi() % movesArray.size()]
	return move
