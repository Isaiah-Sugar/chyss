extends Spatial

var captureColor = Color(0.929688, 0.374054, 0.374054)
onready var mesh = get_node("MeshInstance")

onready var piece = get_parent().get_parent()
onready var board = piece.get_parent().get_parent()
var boardPosition = Vector2(0, 0)

onready var highlightCaptureMat = load("res://capturable.material")
onready var highlightNormalMat = load("res://highlight.material")

func _ready():
	updatePosition()
	if board.positionContents(piece.boardPosition + boardPosition) != "empty":
		mesh.set_surface_material(0, highlightCaptureMat)
	else:
		mesh.set_surface_material(0, highlightNormalMat)

func _on_TextureButton_button_up():
	piece.move(boardPosition, true)

func getClicked():
	piece.move(boardPosition, true)

func updatePosition():
	var tmp = (boardPosition * 1/8)
	translation = Vector3(tmp.x, 0, tmp.y)
