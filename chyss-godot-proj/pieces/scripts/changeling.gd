extends piece

#transforms into a random piece at the start of its turn
#only inherits findMoves, no other properties translate

var newHat = preload("../scenes/Hat.tscn")
var newFrog = preload("../scenes/Frog.tscn")
var newBishop = preload("../scenes/Bishop.tscn")
var newPawn = preload("../scenes/Pawn.tscn")
#var newWheel = preload("res://Wheel.tscn")
var newSorcerer = preload("../scenes/Sorcerer.tscn")
var newRock = preload("../scenes/Rock.tscn")
var newChecker = preload("res://pieces/scenes/Checker.tscn")

#list of the pieces to pick a random one from
var piecesArray = [newHat, newFrog, newBishop, newSorcerer, newRock, newPawn, newChecker]
var childPiece = null

var type = "Changeling"

#on ready get a new child
func individual_ready():
	new_child_piece()

#on next turn if its your turn get a new child
func next_turn(currentTurn):
	if currentTurn == team:
		new_child_piece()

#find moves as the child piece
func find_moves():
	var validMoves = []
	for move in childPiece.find_moves():
		move.piece = self
		validMoves.append(move)
	return validMoves


#function to get a new child piece
func new_child_piece():
	if childPiece:
		remove_child(childPiece)
	
	#get random piece
	var piece = piecesArray[randi() % piecesArray.size()].instance()
	
	#set properties and add it
	piece.boardPosition = self.boardPosition
	piece.team = self.team
	piece.pieceParent = pieceParent
	
	add_child(piece)
	
	childPiece = piece
	childPiece.connect("animation_finished", self, "_on_childPiece_animation_finished")

func _on_childPiece_animation_finished():
	emit_signal("animation_finished")

func set_team(newTeam):
	team = newTeam
	if childPiece:
		childPiece.set_team(newTeam)

func update_position(newPosition):
	boardPosition = newPosition
	
	#fancy saves the rest for entering scene tree
	if not is_inside_tree():
		yield(self, "ready")
	
	#set the visual position of the child piece, own visual position never moves
	if childPiece:
		childPiece.boardPosition = newPosition
