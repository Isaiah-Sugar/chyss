extends piece

var moveVector = Vector2(0, 0)
var type = "Sorcerer"

func individual_ready():
	reroll()

func next_turn(currentTurn):
	if currentTurn == team:
		reroll()

func reroll():
	#roll a random position that doesnt point to a spot occupied by your team
	var randomPosition = Vector2(randi() % 8, randi() % 8)
	while !is_valid_position(randomPosition):
		randomPosition = Vector2(randi() % 8, randi() % 8)
	moveVector = randomPosition - boardPosition

func is_valid_position(position):
	if can_move(position):
		return true
	if can_take(position):
		var positionPiece = pieceParent.find_piece(position)
		if positionPiece.type != "Checker":
			return true
	return false


func find_moves():
	#handle finding captures
	var capturePiece = pieceParent.find_piece(moveVector+boardPosition)
	var captures = []
	if capturePiece:
		captures.append(capturePiece)
	var validMoves = [{team = team, piece = self, vectors = [moveVector + boardPosition], 
						doesCapture = false, captures = captures, score = 0}]
	return validMoves
