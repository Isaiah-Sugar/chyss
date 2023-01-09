extends piece

var moveVectors = [Vector2(0, 1),
					Vector2(0, -1),
					Vector2(1, 0),
					Vector2(-1, 0),
					Vector2(1, 1),
					Vector2(-1, 1),
					Vector2(1, -1),
					Vector2(-1, -1)]
var currentVelocity = Vector2(0, 0)
var type = "Wheel"


#basic find moves by list of vectors
func find_moves():
	var validMoves = []
	if currentVelocity == Vector2(0, 0):
		for vector in moveVectors:
			if  !board.out_of_bounds(boardPosition+vector):
				validMoves.append(vector)
	return validMoves

#on move sets wheel's 'velocity'
func move(moveVector, nextTurn):
	currentVelocity = moveVector
	if nextTurn:
		board.next_turn()

#on next turn wheel rolls according to velocity
func next_turn():
	if currentVelocity != Vector2(0, 0):
		roll()
		stop_check()

#function for the wheel to roll
func roll():
	var capturePiece = board.find_piece(boardPosition+currentVelocity)
	if capturePiece:
		capturePiece.get_captured()
	#must say self for setget to work
	self.boardPosition += currentVelocity

#function to stop the wheel's motion if it hits the edge of the board
func stop_check():
	if board.out_of_bounds(boardPosition+currentVelocity):
		currentVelocity = Vector2(0, 0)
