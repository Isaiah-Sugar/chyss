extends piece

var moveVector = Vector2(0, 0)
var type = "Rock"

func individual_ready():
	whiteTeamMaterial = load("res://materials/rock.material")
	blackTeamMaterial = load("res://materials/rock.material")

func find_moves():
	var validMoves = [{team = team, piece = self, vector = moveVector, capture = null, score = 0}]
	return validMoves
