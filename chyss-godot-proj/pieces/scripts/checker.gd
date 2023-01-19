extends piece

#basic pawn piece
#moves forward one space, cannot capture
#can move backwards any number of spaces only to capture

var moveVectors
var kinged = false
var type = "Checker"

var newChecker = load("res://pieces/scenes/Checker.tscn")

func find_moves():
	var validMoves = []
	
	#check space ahead
	for vector in moveVectors:
		if  can_move(vector):
			validMoves.append({team = team, piece = self, vector = vector, capture = null, captures = null, score = 0})
		elif can_move(vector*2) && can_take(vector):
			var capture = pieceParent.find_piece(vector + boardPosition)
			validMoves.append({team = team, piece = self, vector = vector*2, capture = null, captures = [capture], score = 0})
			#append chain moves to validMoves
			validMoves.append_array(find_chains(validMoves[-1]))
	return validMoves

#function to check if another take can be chained after a take
func find_chains(move):
	var chainMoves = []
	#instance a checker at movePosition
	var chainPiece = newChecker.instance()
	chainPiece.boardPosition = move.vector + boardPosition
	chainPiece.team = team
	chainPiece.kinged = kinged
	chainPiece.pieceParent = pieceParent
	add_child(chainPiece)
	
	for chainMove in chainPiece.find_moves():
		if chainMove.captures:
			chainMoves.append(chainMove)
			chainMove.captures.append_array(move.captures)
			chainMove.vector += move.vector
			chainMove.piece = self
	
	return chainMoves

#invert move vectors depending on team
func individual_set_team():
	if team == "white":
		moveVectors = [Vector2(-1, -1), Vector2(1, -1)]
	else:
		moveVectors = [Vector2(-1, 1), Vector2(1, 1)]

func individual_set_position():
	if team == "white" && boardPosition.y == 0:
		kinged = true
	elif team == "black" && boardPosition.y == 7:
		kinged = true
