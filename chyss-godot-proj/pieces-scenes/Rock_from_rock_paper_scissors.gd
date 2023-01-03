extends "res://piece outline.gd"

var moveVector = Vector2(0, 0)

func findMoves():
	var validMoves = [moveVector]
	return validMoves


#i am isaiah adding these functions:
func setTeam(newTeam):
	team = newTeam #value gets set
	#do not change material based on team
