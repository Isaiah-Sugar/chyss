extends "res://piece_outline.gd"

func _ready():
	moveVectors = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]

func findMoves():
	var validMoves = []
	
	#for each direction piece can move
	for vector in moveVectors:
		var target = vector
		#iterate along vector until a space isnt clear
		while board.positionContents(boardPosition + target) == "empty":
			validMoves.append(target)
			target += vector
		#check if unclear space is takeable
		var positionContents = board.positionContents(boardPosition + target)
		if positionContents != "out" && positionContents != team:
			validMoves.append(target)
	return validMoves 
