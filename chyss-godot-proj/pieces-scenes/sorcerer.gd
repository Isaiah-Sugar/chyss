extends "res://piece-outline.gd"

var moveVector = Vector2(0, 0)

func individual_ready():
	reroll()

func next_turn():
	if board.currentTurn == team:
		reroll()

func reroll():
	#roll a random position that doesnt point to a spot occupied by your team
	var randomPosition = Vector2(randi() % 8, randi() % 8)
	while !can_move(randomPosition - boardPosition) && !can_take(randomPosition - boardPosition):
		randomPosition = Vector2(randi() % 8, randi() % 8)
	moveVector = randomPosition - boardPosition

func find_moves():
	var validMoves = [moveVector]
	return validMoves
