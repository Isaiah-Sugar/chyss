extends piece

#basic pawn piece
#moves forward one space, cannot capture
#can move backwards any number of spaces only to capture

var moveVectors
var kinged = false
var type = "Checker"

func find_moves():
	var validMoves = []
	
	#check space ahead
	for vector in moveVectors:
		if  can_move(vector):
			validMoves.append({team = team, piece = self, vector = vector, capture = null, score = 0})
		elif can_move(vector*2) && can_take(vector):
			var capture = pieceParent.find_piece(vector + boardPosition)
			validMoves.append({team = team, piece = self, vector = vector*2, capture = capture, score = 0})
	return validMoves

#invert move vectors depending on team
func individual_set_team():
	if team == "white":
		moveVectors = [Vector2(-1, -1), Vector2(1, -1)]
	else:
		moveVectors = [Vector2(-1, 1), Vector2(1, 1)]
