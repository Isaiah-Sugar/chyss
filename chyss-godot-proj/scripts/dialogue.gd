extends Spatial

var dialogue = preload("res://dialogue/test dialogue.tres")
var frogFlag = false

#to add a dialogue case make a bool function for its execution, the name of its dialogue node, if you want it to repeat, set alreadyHappened to null 
var caseArray = [
					{function = "opening_dialogue(move, turnNumber)", dialogueNode = "opening_dialogue", alreadyHappened = false},
					{function = "frog_reveal(move, turnNumber)", dialogueNode = "frog_reveal", alreadyHappened = false}
																																]

func determine_dialogue(move, turnNumber):
	for case in caseArray:
		if case.alreadyHappened:
			continue
		
		if evaluate(case.function, ["move", "turnNumber"], [move, turnNumber]):
			DialogueManager.show_example_dialogue_balloon(case.dialogueNode, dialogue)
			if case.alreadyHappened && case.alredyHappened == false:
				case.alreadyHappened = true

func evaluate(command, variable_names = [], variable_values = []):
	var expression = Expression.new()
	var error = expression.parse(command, variable_names)
	if error != OK:
		push_error(expression.get_error_text())
		return
	
	var result = expression.execute(variable_values, self)
	
	if not expression.has_execute_failed():
		return result

func opening_dialogue(_move, turnNumber : int) -> bool:
	if turnNumber == 0:
		return true
	return false

func frog_reveal(move, _turnNumber : int) -> bool:
	if move && move.capture && move.capture.type == "Hat":
		return true
	return false
