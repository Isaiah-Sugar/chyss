extends Spatial

#script for the parent of pieces, mostly just helps pieces talk to each other

#called by main, tells every piece whose turn it is
func tell_pieces_turn(team):
	for piece in get_children():
		piece.next_turn(team)

#returns true if provided position is out of bounds
func out_of_bounds(position):
	if position.y > 7 || position.y < 0 || position.x > 7 || position.x < 0:
		return true

#function to find a piece at a given position
func find_piece(position):
	for piece in get_children():
		if piece.boardPosition == position:
			return piece
	return null
