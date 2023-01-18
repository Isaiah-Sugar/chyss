extends Spatial

signal dialogue_finished

var dialogue = preload("res://dialogue/test dialogue.tres")

var dialogueQueue = []
var oppenentTeam = "black"

#function to determine dialogue event
func queue_dialogue(variableNames, variableValues):
	
	#evaluates each special dialogue case 
	for case in caseArray:
		#continue if its already been shown
		if case.alreadyHappened:
			continue
		
		#continue if its variables are not among passed in variables
		var continueFlag = false
		for caseVariableName in case.variableNames:
			if variableNames.find(caseVariableName) == -1:
				continueFlag = true
		if continueFlag == true:
			continue
		
		#get the values of its variables in an array
		var caseVariableValues = []
		for caseVariableName in case.variableNames:
			caseVariableValues.append(variableValues[variableNames.find(caseVariableName)])
		
		#evaluate its condition and display it if its condition is true
		if evaluate(case.function, case.variableNames, caseVariableValues):
			dialogueQueue.append(case.dialogueNode)
			if case.alreadyHappened != null:
				case.alreadyHappened = true

func play_queue():
	if dialogueQueue.size() > 0:
		for node in dialogueQueue:
			DialogueManager.show_example_dialogue_balloon(node, dialogue)
			yield(DialogueManager, "dialogue_finished")
	dialogueQueue.clear()
	emit_signal("dialogue_finished")

#function to evaluate dialogue "function strings"
func evaluate(command, variableNames = [], variableValues = []):
	var expression = Expression.new()
	var error = expression.parse(command, variableNames)
	if error != OK:
		push_error(expression.get_error_text())
		return

	var result = expression.execute(variableValues, self)

	if not expression.has_execute_failed():
		return result


#special dialgue case stuff:

#to add a dialogue case make a bool function for its execution, the name of its dialogue node, if you want it to repeat, set alreadyHappened to null 
var caseArray = [
					{function = "opening_dialogue(turnNumber)", variableNames = ["turnNumber"], dialogueNode = "opening_dialogue", alreadyHappened = false},
					{function = "frog_reveal(move)", variableNames = ["move"], dialogueNode = "frog_reveal", alreadyHappened = false},
					{function = "good_move(move)", variableNames = ["move"], dialogueNode = "good_move", alreadyHappened = null},
#					{function = "ur_mom(turnNumber)", variableNames = ["turnNumber"], dialogueNode = "ur_mom", alreadyHappened = false},
					{function = "uses_both(move, turnNumber)", variableNames = ["move", "turnNumber"], dialogueNode = "uses_both", alreadyHappened = false}
																																]
#special case bool functions
func opening_dialogue(turnNumber : int) -> bool:
	if turnNumber == 0:
		return true
	return false
func frog_reveal(move) -> bool:
	if move && move.capture && move.capture.type == "Hat":
		return true
	return false
func good_move(move) -> bool:
	if move && move.team == oppenentTeam && move.score > 15:
		return true
	return false
func ur_mom(turnNumber : int) -> bool:
	if turnNumber == 1:
		return true
	return false
func uses_both(move, turnNumber):
	if move.piece.type == "Hat" && turnNumber == 3:
		return true
	return false
