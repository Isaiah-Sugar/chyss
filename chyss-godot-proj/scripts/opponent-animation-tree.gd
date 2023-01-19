extends AnimationTree

#this is an isaiah script, it does animations for the guy

var playback : AnimationNodeStateMachinePlayback


# Called when the node enters the scene tree for the first time.
func _ready():
	playback = get("parameters/StateMachine/playback")
	print(playback)
	playback.start("hand-rest-on-table")
	dumbass_loop()


func dumbass_loop():
	while true:
		yield(get_tree().create_timer(0.3), "timeout")
		if percentageChance(.1):
			playback.travel("hand-tapping")
			for i in intRandomInRange(0,3):
				yield(get_tree().create_timer(get_node(anim_player).get_animation("hand-tapping").length), "timeout")
				playback.start(playback.get_current_node())
		else:
			playback.travel("hand-rest-on-table")
			yield(get_tree().create_timer(0.5), "timeout")


#return true some percent of the time, chance input is 0 to 1
func percentageChance(chance:float) -> bool:
	if (fmod(randf(),1.0)>chance):
		return true
	return false

func floatRandomInRange(lowbound:float, highbound:float) -> float:
	return lerp(lowbound, highbound, fmod(randf(),1.0))

func intRandomInRange(lowbound:int, highbound:int) -> int:
	return lowbound + (randi() % (highbound-lowbound))
