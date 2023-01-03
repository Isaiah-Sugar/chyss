#bg objects to add
#plant, dice, game controller, card game deck box, book

#todo
#isaiah add sorcerer model to sorcerer.tscn, its a hat rn


extends Spatial

onready var camera = get_node("Camera")
onready var rayCastObj = get_node("Camera/RayCast")
const ray_length = 1000
var hoveredObj = null

onready var board = get_node("chyss table bits/board")

var camMoveInput = 0
var camMoveSpeed = .05


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
	else: #i do not like how this reads but it seems to work fine:
		#if one is released and the other isn't held
		if (event.is_action_released("cam-forward") and !event.is_action_pressed("cam-back"))\
		or (event.is_action_released("cam-back") and !event.is_action_pressed("cam-forward")):
			camMoveInput = 0
		#if one or both is pressed
		if event.is_action_pressed("cam-forward") or event.is_action_pressed("cam-back"):
			camMoveInput = 0
			if event.is_action_pressed("cam-forward"):
				camMoveInput += 1
			if event.is_action_pressed("cam-back"):
				camMoveInput -= 1

func _process(delta):
	if camMoveInput != 0:
		print("cam: "+str(camMoveInput))

func camPath(factor: float) -> Vector3:
	pass
