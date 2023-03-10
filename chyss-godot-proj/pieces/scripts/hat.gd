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
		#handle finding captures
		if can_move(vector + boardPosition) || can_take(vector + boardPosition):
			var capturePiece = pieceParent.find_piece(vector+boardPosition)
			var captures = []
			if capturePiece:
				captures.append(capturePiece)
			
			#append the move to the array
			validMoves.append({team = team, piece = self, vectors = [vector + boardPosition],
								doesCapture = false, captures = captures, score = 0})
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

