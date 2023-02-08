extends piece


var moveVectors = [
					Vector2(3, -1), 
					Vector2(3, 0), 
					Vector2(3, 1), 
					Vector2(-3, -1),
					Vector2(-3, 0),
					Vector2(-3, 1),
					Vector2(-1, 3),
					Vector2(0, 3),
					Vector2(1, 3),
					Vector2(-1, -3),
					Vector2(0, -3),
					Vector2(1, -3),
					Vector2(2, 2),
					Vector2(2, -2),
					Vector2(-2, 2),
					Vector2(-2, -2)
									]
var type = "Frog"

func find_moves():
	var validMoves = []
	for vector in moveVectors:
		if can_move(vector + boardPosition) || can_take(vector+boardPosition):
			#handle finding captures
			var capturePiece = pieceParent.find_piece(vector+boardPosition)
			var captures = []
			if capturePiece:
				captures.append(capturePiece)
			
			#append the move to the array
			validMoves.append({team = team, piece = self, vectors = [vector + boardPosition],
								doesCapture = false, captures = captures, score = 0})
	return validMoves
