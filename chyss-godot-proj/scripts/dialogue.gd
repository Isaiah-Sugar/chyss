extends Spatial

signal dialogue_finished

var dialogue = preload("res://dialogue/test dialogue.tres")

var dialogueQueue = []
var oppenentTeam = "black"

#function to determine dialogue event
func queue_dialogue(move, turnNumber):
	
	#evaluates each special dialogue case 
	for case in caseArray:
		if case.alreadyHappened:
			continue
		if evaluate(case.function, ["move", "turnNumber"], [move, turnNumber]):
			dialogueQueue.append(case.dialogueNode)
			if case.alreadyHappened != null:
				case.alreadyHappened = true
		
	play_queue()

func play_queue():
	if dialogueQueue.size() > 0:
		for node in dialogueQueue:
			DialogueManager.show_example_dialogue_balloon(node, dialogue)
			yield(DialogueManager, "dialogue_finished")
	dialogueQueue.clear()
	emit_signal("dialogue_finished")

#function to evaluate dialogue "function strings"
func evaluate(command, variable_names = [], variable_values = []):
	var expression = Expression.new()
	var error = expression.parse(command, variable_names)
	if error != OK:
		push_error(expression.get_error_text())
		return

	var result = expression.execute(variable_values, self)

	if not expression.has_execute_failed():
		return result


#special dialgue case stuff:

#to add a dialogue case make a bool function for its execution, the name of its dialogue node, if you want it to repeat, set alreadyHappened to null 
var caseArray = [
					{function = "opening_dialogue(move, turnNumber)", dialogueNode = "opening_dialogue", alreadyHappened = false},
					{function = "frog_reveal(move, turnNumber)", dialogueNode = "frog_reveal", alreadyHappened = false},
					{function = "good_move(move, turnNumber)", dialogueNode = "good_move", alreadyHappened = null},
					{function = "ur_mom(move, turnNumber)", dialogueNode = "ur_mom", alreadyHappened = false}
																																]
#special case bool functions
func opening_dialogue(_move, turnNumber : int) -> bool:
	if turnNumber == 0:
		return true
	return false

func frog_reveal(move, _turnNumber : int) -> bool:
	if move && move.capture && move.capture.type == "Hat":
		return true
	return false

func good_move(move, _turnNumber : int) -> bool:
	if move && move.team == oppenentTeam && move.score > 15:
		return true
	return false

func ur_mom(_move, turnNumber : int) -> bool:
	if turnNumber == 1:
		return true
	return false
