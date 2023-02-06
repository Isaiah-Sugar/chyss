extends Spatial
#Instanced by human player ti show possible moves for a piece, when clicked their move var is made by player

#other nodes
onready var mesh = get_node("MeshInstance")
onready var board = get_parent().board
onready var pieceParent = board.get_node("PieceParent")

#material preloads
onready var highlightCaptureMat = load("res://materials/capturable.material")
onready var highlightNormalMat = load("res://materials/highlight.material")

#highlight parameters
var boardPosition = Vector2(0, 0)
var move = null

#function to update material based on if capture
func _ready():
	boardPosition = move.vectors[-1]
	update_position()
	if move.captures && move.captures != [null]:
		mesh.set_surface_material(0, highlightCaptureMat)
	else:
		mesh.set_surface_material(0, highlightNormalMat)
#function to update the position the highlight is displayed at
func update_position():
	var tmp = (boardPosition * 1/8)
	translation = Vector3(tmp.x, 0, tmp.y)
