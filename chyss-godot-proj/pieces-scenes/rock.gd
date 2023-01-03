extends "res://piece-outline.gd"

var moveVector = Vector2(0, 0)

func find_moves():
	var validMoves = [moveVector]
	return validMoves


#i am isaiah adding these functions:
func set_team(newTeam):
	team = newTeam #value gets set
	#do not change material based on team
