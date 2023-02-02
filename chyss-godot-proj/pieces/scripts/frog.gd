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
		if can_move(vector) || can_take(vector):
			var capture = pieceParent.find_piece(vector+boardPosition)
			validMoves.append({team = team, piece = self, vectors = [vector],
								doesCapture = false, captures = [capture], score = 0})
			if capture:
				validMoves[-1].doesCapture = true
	return validMoves
