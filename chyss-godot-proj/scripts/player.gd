extends Spatial

onready var board = get_parent()
onready var camera = get_node("/root/Main/Camera")
onready var rayCast = camera.get_node("RayCast")
var hoveredObj = null

var team

func _input(event):
	#if its my turn
	if board.currentTurn == team:
		#if left mouse press down
		if event is InputEventMouseButton && event.button_index == 1 && event.pressed:
			var clickTarget = rayCast.cast_ray()
			print(clickTarget)
			if clickTarget:  # clicked on hovered object 
				clickTarget.get_clicked()
			else:  # unselect if clicked on no object
				board.unselect()


