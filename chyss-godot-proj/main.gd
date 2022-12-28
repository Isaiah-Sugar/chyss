#bg objects to add
#plant, dice, game controller, card game deck box, book

extends Spatial

onready var camera = get_node("Camera")
onready var rayCastObj = get_node("Camera/RayCast")
const ray_length = 1000
var hoveredObj = null

onready var board = get_node("chyss table bits/board")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton && event.button_index == 1 && event.pressed:
		if hoveredObj:
			hoveredObj.getClicked()
		else:
			board.unselect()
	elif event is InputEventMouseMotion:
		var from = camera.project_ray_origin(event.position)
		rayCastObj.cast_to = rayCastObj.global_translation + camera.project_local_ray_normal(event.position) * ray_length
		if rayCastObj.get_collider() != hoveredObj:
			hoveredObj = rayCastObj.get_collider()
			print(hoveredObj)
