extends RayCast

onready var camera = get_parent()
const ray_length = 1000

func cast_ray():
	cast_to = global_translation + camera.project_local_ray_normal(get_viewport().get_mouse_position()) * ray_length
	force_raycast_update()
	return get_collider() #update hovered object
