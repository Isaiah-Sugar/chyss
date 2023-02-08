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
			validMoves.append_array(find_chains(validMoves[-1]))
	for move in validMoves:
		move.captures.invert()
	return validMoves

#function to check if another take can be chained after a take
func find_chains(move):
	var chainMoves = []
	#instance a checker at movePosition
	var chainPiece = newChecker.instance()
	chainPiece.boardPosition = move.vectors[-1]
	chainPiece.team = team
	chainPiece.kinged = kinged
	chainPiece.pieceParent = pieceParent
	chainPiece.visible = false
	add_child(chainPiece)
	
	#for every move the chain piece can make
	for chainMove in chainPiece.find_moves():
		#if it captures anything
		if chainMove.captures.size() > 0:
			#append chain move to our array of chain moves
			chainMoves.append(chainMove)
			#append the initial move's captures to the chain move
			chainMove.captures.append_array(move.captures)
			
			for vector in move.vectors:
				chainMove.vectors.insert(0, vector)
			chainMove.piece = self
	
	remove_child(chainPiece)
	chainPiece.queue_free()
	return chainMoves

#invert move vectors depending on team
func individual_set_team():
	if team == "white":
		moveVectors = [Vector2(-1, -1), Vector2(1, -1)]
	else:
		moveVectors = [Vector2(-1, 1), Vector2(1, 1)]

func individual_set_position():
	if team == "white" && boardPosition.y == 0:
		get_kinged()
	elif team == "black" && boardPosition.y == 7:
		get_kinged()

func get_kinged():
	kinged = true
	get_node("checker").visible = false
	get_node("collision-checker").visible = false
	get_node("checker-kinged").visible = true
	get_node("collision-kinged").visible = true
	for vector in moveVectors:
		moveVectors.append(vector * -1)



