extends Spatial

#script for the parent of pieces, can find one by its position

func out_of_bounds(position):
	if position.y > 7 || position.y < 0 || position.x > 7 || position.x < 0:
		return true

#function to find a piece at a given position
func find_piece(position):
	for piece in get_children():
		if piece.boardPosition == position:
			return piece
	return null
