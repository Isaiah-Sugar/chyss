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
	while !can_move(randomPosition - boardPosition) && !can_take(randomPosition - boardPosition):
		randomPosition = Vector2(randi() % 8, randi() % 8)
	moveVector = randomPosition - boardPosition

func find_moves():
	var capture = pieceParent.find_piece(moveVector+boardPosition)
	var validMoves = [{team = team, piece = self, vectors = [moveVector], 
						doesCapture = false, captures = [capture], score = 0}]
	if capture:
		validMoves[-1].doesCapture = true
	return validMoves
