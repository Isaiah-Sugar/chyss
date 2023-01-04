extends "res://piece-outline.gd"

#basic pawn piece
#moves forward one space, cannot capture
#can move backwards any number of spaces only to capture

var moveVector
var captureVector

func find_moves():
	var validMoves = []
	
	#check space ahead
	if  can_move(moveVector):
		validMoves.append(moveVector)
	
	#find first obstructed space on vector
	var targetVector = captureVector
	while(can_move(targetVector)):
		targetVector += captureVector
	if  can_take(targetVector):
		validMoves.append(targetVector)
	return validMoves

#invert move vectors depending on team
func individual_set_team():
	if team == "white":
		moveVector = Vector2(0, -1)
		captureVector =  Vector2(0, 1)
	else:
		moveVector = Vector2(0, 1)
		captureVector =  Vector2(0, -1)
