extends "res://piece-outline.gd"

var moveVector = Vector2(0, 0)

func individual_ready():
	whiteTeamMaterial = load("res://rock.material")
	blackTeamMaterial = load("res://rock.material")

func find_moves():
	var validMoves = [moveVector]
	return validMoves
