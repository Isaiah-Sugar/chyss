extends piece
var moveVectors = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]

func find_moves():
	var validMoves = []
	#for each direction piece can move
	for vector in moveVectors:
		var target = vector
		#iterate along vector until a space isnt clear
		while can_move(target):
			validMoves.append(target)
			target += vector
		#check if unclear space is takeable
		if can_take(target):
			validMoves.append(target)
	return validMoves 

