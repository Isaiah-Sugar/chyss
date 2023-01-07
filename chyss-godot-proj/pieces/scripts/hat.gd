extends piece

var newFrog = preload("res://pieces/scenes/Frog.tscn")

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
var type = "Hat"

func find_moves():
	var validMoves = []
	for vector in moveVectors:
		if can_move(vector) || can_take(vector):
			validMoves.append(vector)
	return validMoves

func get_captured():
	spawn_frog()
	queue_free()

#spawn a frog on the position where hat is killed
func spawn_frog():
	var frog = newFrog.instance()
	frog.boardPosition = boardPosition
	get_parent().add_child(frog)
	frog.team = team
	frog.random_move()

