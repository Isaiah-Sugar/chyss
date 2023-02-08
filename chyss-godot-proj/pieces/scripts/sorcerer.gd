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
	while !can_move(randomPosition) && !can_take(randomPosition):
		randomPosition = Vector2(randi() % 8, randi() % 8)
	moveVector = randomPosition - boardPosition

func find_moves():
				#handle finding captures
	var capturePiece = pieceParent.find_piece(moveVector+boardPosition)
	var captures = []
	if capturePiece:
		captures.append(capturePiece)
	var validMoves = [{team = team, piece = self, vectors = [moveVector + boardPosition], 
						doesCapture = false, captures = captures, score = 0}]
	return validMoves
