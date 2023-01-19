extends Camera

#this one is nonsense to me what is a lerp
#lets player move camera i know that much

var camMoveInput = 0
#factor per second,, the reciprocal of this value is how many seconds it takes the camera to move all the way
var camMoveSpeed = .4
var camPathFac = 0

const camMinPos = Vector3(0,1.472,1.715)
const camMaxPos = Vector3(0,3,0)
const camMinRot = Vector3(-16.9810,0,0)
const camMaxRot = Vector3(-90,0,0)

func _ready():
	cam_path(camPathFac)

func _input(event):
	#i do not like how this reads but it seems to work fine:
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
		camPathFac += (camMoveInput * camMoveSpeed * delta )
		camPathFac = max(min(camPathFac,1),0) #clamp to a 0-1 range
		cam_path(camPathFac)

func cam_path(factor: float) -> void:
	translation = lerp(camMinPos, camMaxPos, factor)
	rotation_degrees = lerp(camMinRot, camMaxRot, factor)
