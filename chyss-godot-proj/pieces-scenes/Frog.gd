extends "res://piece outline.gd"


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
	

func findMoves():
	var validMoves = []
	for vector in moveVectors:
		var positionContents = board.positionContents(boardPosition+vector)
		if  positionContents != "out" && positionContents != team:
			validMoves.append(vector)
	return validMoves
