extends "res://piece outline.gd"

var newFrog = preload("res://pieces-scenes/frog.tscn")

var moveVectors = [
					Vector2(2, -1), 
					Vector2(2, 0), 
					Vector2(2, 1), 
					Vector2(-2, -1),
					Vector2(-2, 0),
					Vector2(-2, 1),
					Vector2(-1, 2),
					Vector2(0, 2),
					Vector2(1, 2),
					Vector2(-1, -2),
					Vector2(0, -2),
					Vector2(1, -2)
									]

func findMoves():
	var validMoves = []
	for vector in moveVectors:
		if canMove(vector) || canTake(vector):
			validMoves.append(vector)
	return validMoves

func getCaptured():
	spawnFrog()
	queue_free()

#spawn a frog on the position where hat is killed
func spawnFrog():
	var frog = newFrog.instance()
	frog.boardPosition = boardPosition
	get_parent().add_child(frog)
	frog.team = team
	frog.randomMove()

