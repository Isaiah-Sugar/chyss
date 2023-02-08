extends piece

#Bishop piece can move diagonally any distance

var moveVectors = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
var type = "Bishop"

func find_moves():
	var validMoves = []
	#for each direction piece can move
	for vector in moveVectors:
		var target = vector
		#iterate along vector until a space isnt clear
		while can_move(target + boardPosition):
			validMoves.append({team = team, piece = self, vectors = [target + boardPosition], 
								doesCapture = true, captures = [], score = 0})
			target += vector
		#check if unclear space is takeable
		if can_take(target + boardPosition):
			var capture = pieceParent.find_piece(target+boardPosition)
			validMoves.append({team = team, piece = self, vectors = [target + boardPosition], 
								doesCapture = true, captures = [capture], score = 0})
	return validMoves 

