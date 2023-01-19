extends piece
var moveVectors = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
var type = "Bishop"

func find_moves():
	var validMoves = []
	#for each direction piece can move
	for vector in moveVectors:
		var target = vector
		#iterate along vector until a space isnt clear
		while can_move(target):
			validMoves.append({team = team, piece = self, vector = target, captures = [], score = 0})
			target += vector
		#check if unclear space is takeable
		if can_take(target):
			var capture = pieceParent.find_piece(target+boardPosition)
			validMoves.append({team = team, piece = self, vector = target, captures = [capture], score = 0})
	return validMoves 

