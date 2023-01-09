extends Spatial

var captureColor = Color(0.929688, 0.374054, 0.374054)
onready var mesh = get_node("MeshInstance")

onready var board = get_parent().board
onready var pieceParent = board.get_node("PieceParent")
var boardPosition = Vector2(0, 0)

onready var highlightCaptureMat = load("res://materials/capturable.material")
onready var highlightNormalMat = load("res://materials/highlight.material")

func _ready():
	update_position()
	if pieceParent.find_piece(boardPosition):
		mesh.set_surface_material(0, highlightCaptureMat)
	else:
		mesh.set_surface_material(0, highlightNormalMat)

func update_position():
	var tmp = (boardPosition * 1/8)
	translation = Vector3(tmp.x, 0, tmp.y)
