extends "res://piece outline.gd"

var moveVector = Vector2(0, 0)

func _ready():
	getOtherNodes()
	nextTurn()
	updatePosition()

func nextTurn():
	if board.currentTurn == team:
		reroll()

func reroll():
	#roll a random position that doesnt point to a spot occupied by your team
	var randomPosition = Vector2(randi() % 8, randi() % 8)
	while(board.positionContents(randomPosition) == team):
		randomPosition = Vector2(randi() % 8, randi() % 8)
	moveVector = randomPosition - boardPosition

func findMoves():
	var validMoves = [moveVector]
	return validMoves
