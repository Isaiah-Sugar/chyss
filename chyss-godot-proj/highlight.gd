extends Spatial

var captureColor = Color(0.929688, 0.374054, 0.374054)
onready var mesh = get_node("MeshInstance")

onready var piece = get_parent().get_parent()
onready var board = piece.board
var boardPosition = Vector2(0, 0)

onready var highlightCaptureMat = load("res://capturable.material")
onready var highlightNormalMat = load("res://highlight.material")

func _ready():
	update_position()
	if board.find_piece(piece.boardPosition + boardPosition):
		mesh.set_surface_material(0, highlightCaptureMat)
	else:
		mesh.set_surface_material(0, highlightNormalMat)

func get_clicked():
	piece.move(boardPosition, true)

func update_position():
	var tmp = (boardPosition * 1/8)
	translation = Vector3(tmp.x, 0, tmp.y)
