extends Player

onready var camera = get_node("/root/Main/Camera")
onready var rayCast = camera.get_node("RayCast")
var hoveredObj = null

var newHighlight = preload("res://scenes/Highlight.tscn")


var playing
var validMoves = []
var selectedMoves = []

#function to find a list of moves at the start of turn
func play_turn():
	playing = true
	validMoves = find_moves()

#function to handle player mouse input
func _input(event):
	#if its my turn
	if playing:
		#if left mouse press down
		if event is InputEventMouseButton && event.button_index == 1 && event.pressed:
			var clickTarget = rayCast.cast_ray()
			if clickTarget:  # clicked on hovered object 
				click(clickTarget)
			else:  # unselect if clicked on no object
				unselect()

#function to execute a click
#if a highlight was clicked, make the highlight's move
#if a pieces was clicked, show its moves as highlights
func click(clickTarget):
	var clickLocation = clickTarget.boardPosition
	
	#check if click location is highlighted
	for highlight in get_children():
		if highlight.boardPosition == clickLocation:
			#selectedPiece.move(clickLocation)
			make_move(highlight.move)
			playing = false
			unselect()
			return
	
	#if a highlight wasnt clicked unselect
	unselect()
	
	
	#find piece clicked on
	for piece in pieceParent.get_children():
		if piece.boardPosition == clickLocation && piece.team == team:
			select_piece(piece)


#function to unselect current piece
func unselect():
	for highlight in get_children():
		highlight.queue_free()

#function to select a piece
func select_piece(piece):
	for move in validMoves:
		if move.piece == piece:
			var highlight = newHighlight.instance()
			highlight.move = move
			add_child(highlight)


