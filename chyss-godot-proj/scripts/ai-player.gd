extends Player

#Script to play game as an ai, instanced as a child of board
#On its turn it finds all its moves, scores them, then picks a move and makes it

onready var thinkTimer = get_node("ThinkTimer")
var jailedPiece = null
const jailPosition = Vector2(-1.8, 3.5)

#function to play the ai's turn
func play_turn():
	#wait until the think timer is finished
	thinkTimer.start()
	yield(thinkTimer, "timeout")
	
	#90% chance to make a normal move
	if randi() % 10 > 0:
		#find all your moves
		var movesArray = find_moves()
		#score the moves
		var dangerArray = find_danger()
		for move in movesArray:
			score_move(move, dangerArray)
		#pick a move and make it
		var move = pick_move(movesArray)
		make_move(move)
	#10% chance to jail a piece
	else:
		#pick a random piece
		var pieces = pieceParent.get_children()
		var jailPiece = pieces[randi() % pieces.size()]
		#send it to jail
		jail_piece(jailPiece)

#fancy custom sorter
class ScoreSorter:
	static func sort_by_score(a, b):
		if a.score < b.score:
			return true
		return false
#function to pick a move from the array
func pick_move(movesArray):
	#sort
	movesArray.sort_custom(ScoreSorter, "sort_by_score")
	
	#remove moves that score too low (3 less than the highest score)
	var i = movesArray.size()
	while i > 0:
		i -= 1
		if movesArray[-1].score - movesArray[i].score >= 3:
			movesArray.pop_at(i)
	#pick a random remaining move
	var move = movesArray[randi() % movesArray.size()]
	return move

func jail_piece(piece):
	#unjail current piece
	if jailedPiece:
		jailedPiece.boardPosition = piece.boardPosition
		jailedPiece.jailed = false
	#jail new piece
	jailedPiece = piece
	piece.jailed = true
	piece.boardPosition = jailPosition
	if piece.type == "Wheel":
		piece.velocity = Vector2(0, 0)
	#append dialogue and emit signal
	Dialogue.append_queue(["jailedPiece"], [piece])
	board.call_deferred("emit_signal", "move_made")
