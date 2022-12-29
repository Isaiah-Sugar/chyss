#bg objects to add
#plant, dice, game controller, card game deck box, book

extends Spatial

onready var camera = get_node("Camera")
onready var rayCastObj = get_node("Camera/RayCast")
const ray_length = 1000
var hoveredObj = null

onready var board = get_node("chyss table bits/board")


func _ready():
	pass

func _input(event):
	#if left mouse press down
	if event is InputEventMouseButton && event.button_index == 1 && event.pressed:
		if hoveredObj:  # clicked on hovered object 
			hoveredObj.getClicked()
		else:  # unselect if clicked on no object
			board.unselect()
	elif event is InputEventMouseMotion:
		#set raycast destination
		rayCastObj.cast_to = rayCastObj.global_translation + camera.project_local_ray_normal(event.position) * ray_length
		if rayCastObj.get_collider() != hoveredObj: #hovering over a different object
			hoveredObj = rayCastObj.get_collider() #update hovered object
