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
			var capture = pieceParent.find_piece(vector+boardPosition)
			validMoves.append({team = team, piece = self, vectors = [vector],
								doesCapture = false, captures = [capture], score = 0})
			if capture:
				validMoves[-1].doesCapture = true
	return validMoves

func individual_get_captured():
	spawn_frog()

#spawn a frog on the position where hat is killed
func spawn_frog():
	var frog = newFrog.instance()
	frog.boardPosition = boardPosition
	get_parent().add_child(frog)
	frog.team = team
	frog.random_move()

