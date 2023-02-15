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
		#non-capture diagonal move
		if  can_move(vector + boardPosition):
			validMoves.append({team = team, piece = self, vectors = [vector + boardPosition], 
								doesCapture = false, captures = [], score = 0})
		#capture move, jump over capture
		elif can_move(vector*2 + boardPosition) && can_take(vector + boardPosition):
			var capture = pieceParent.find_piece(vector + boardPosition)
			validMoves.append({team = team, piece = self, vectors = [vector*2 + boardPosition], 
								doesCapture = true, captures = [capture], score = 0})
			#append chain moves to validMoves
			validMoves.append_array(find_chains(validMoves[-1], vector*-1))
		elif can_move(vector*2 + boardPosition):
			validMoves.append({team = team, piece = self, vectors = [vector*2 + boardPosition], 
								doesCapture = false, captures = [], score = 0})
	
	return validMoves

#function to check if another take can be chained after a take
func find_chains(move, ignoreVector):
	var chainMoves = []
	for vector in moveVectors:
		if vector == ignoreVector:
			continue
		if can_move(vector*2 + move.vectors[-1]) && can_take(vector + move.vectors[-1]):
			var capture = pieceParent.find_piece(vector + move.vectors[-1])
			chainMoves.append(move.duplicate(true))
			chainMoves[-1].vectors.append(vector*2 + move.vectors[-1])
			chainMoves[-1].captures.append(capture)
			chainMoves.append_array(find_chains(chainMoves[-1], vector*-1))
	return chainMoves
			

#invert move vectors depending on team
func individual_set_team():
	if kinged:
		moveVectors = [Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1), Vector2(1, 1)]
	elif team == "white":
		moveVectors = [Vector2(-1, -1), Vector2(1, -1)]
	else:
		moveVectors = [Vector2(-1, 1), Vector2(1, 1)]

func individual_set_position():
	if team == "white" && boardPosition.y == 0:
		get_kinged()
	elif team == "black" && boardPosition.y == 7:
		get_kinged()

func get_kinged():
	yield(self, "animation_finished")
	kinged = true
	get_node("checker").visible = false
	get_node("collision-checker").visible = false
	get_node("checker-kinged").visible = true
	get_node("collision-kinged").visible = true
	mesh = get_node("checker-kinged")
	self.team = team



