extends "res://piece-outline.gd"


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
	

func find_moves():
	var validMoves = []
	for vector in moveVectors:
		if can_move(vector) || can_take(vector):
			validMoves.append(vector)
	return validMoves
