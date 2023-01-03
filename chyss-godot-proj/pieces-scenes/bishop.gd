extends "res://piece-outline.gd"
var moveVectors = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]

func findMoves():
	var validMoves = []
	#for each direction piece can move
	for vector in moveVectors:
		var target = vector
		#iterate along vector until a space isnt clear
		while canMove(target):
			validMoves.append(target)
			target += vector
		#check if unclear space is takeable
		if canTake(target):
			validMoves.append(target)
	return validMoves 

