extends RayCast

onready var camera = get_parent()
const ray_length = 1000

var hoveredObject
var mousePosition

func _input(event):
	if event is InputEventMouseMotion:
	#set raycast destination
		cast_ray()
		mousePosition = event.position
		#print(mousePosition)
		#hoveredObject = cast_ray()

func cast_ray():
	cast_to = global_translation + camera.project_local_ray_normal(get_viewport().get_mouse_position()) * ray_length
	print(get_collider())
	return get_collider() #update hovered object
