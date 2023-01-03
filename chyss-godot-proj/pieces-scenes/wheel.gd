extends "res://piece-outline.gd"

var moveVectors = [Vector2(0, 1),
					Vector2(0, -1),
					Vector2(1, 0),
					Vector2(-1, 0),
					Vector2(1, 1),
					Vector2(-1, 1),
					Vector2(1, -1),
					Vector2(-1, -1)]

var currentVelocity = Vector2(0, 0)

#needs to not get clikced if it has a velocity
func get_clicked():
	if currentVelocity == Vector2(0, 0):
		if team == board.currentTurn:
			board.unselect()
			var validMoves = find_moves()
			spawn_highlights(validMoves)

#basic find moves by list of vectors
func find_moves():
	var validMoves = []
	for vector in moveVectors:
		if  can_move(vector):
			validMoves.append(vector)
	return validMoves

#on move sets wheel's 'velocity'
func move(moveVector, nextTurn):
	currentVelocity = moveVector
	if nextTurn:
		board.next_turn()

#on next turn wheel rolls according to velocity
func next_turn():
	stop_check()
	if currentVelocity != Vector2(0, 0):
		roll()

#function for the wheel to roll
func roll():
	var capturePiece = board.find_piece(boardPosition+currentVelocity)
	if capturePiece:
		capturePiece.get_captured()
	boardPosition += currentVelocity
	update_position()

#function to stop the wheel's motion if it hits the edge of the board
func stop_check():
	if board.out_of_bounds(boardPosition+currentVelocity):
		currentVelocity = Vector2(0, 0)
