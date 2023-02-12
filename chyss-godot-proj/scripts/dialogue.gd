extends Spatial

#Singleton script to handle dialogue

#signal to main
signal all_dialogue_finished

#dialogue file
var dialogue = preload("res://dialogue/test dialogue.tres")


#variables to be used for dialogue queueing
var queuedVariableNames = []
var queuedVariableValues = []

#debug bool to turn off dialogue (its annoying)
var doDialogue = true

var randFloat = 0 setget , get_rand_float
var tmp_store = 0

#vars to store dialogue info
var jailedAlready = false

func get_rand_float():
	return randf()

#queued dialogue nodes
var dialogueQueue = []
#opponenets team
var oppenentTeam = "black"

#append a varibale name and value to the queued variables
func append_queue(variableNames, variableValues):
	for name in variableNames:
		queuedVariableNames.append(name)
	for value in variableValues:
		queuedVariableValues.append(value)
	
#uses queued variables to queue dialogue nodes
func queue_dialogue():
	#evaluates each special dialogue case 
	for case in caseArray:
		#continue if its already been shown
		if case.alreadyHappened:
			continue
		
		#continue if case's variables are not among queued in variables
		var continueFlag = false
		for caseVariableName in case.variableNames:
			if queuedVariableNames.find(caseVariableName) == -1:
				continueFlag = true
		if continueFlag == true:
			continue
		
		#get the values of case's variables in an array
		var caseVariableValues = []
		for caseVariableName in case.variableNames:
			var index = queuedVariableNames.find(caseVariableName)
			caseVariableValues.append(queuedVariableValues[index])
		
		#evaluate its condition and queue case's node if its condition is true
		if evaluate(case.function, case.variableNames, caseVariableValues):
			dialogueQueue.append(case.dialogueNode)
			if case.alreadyHappened != null:
				case.alreadyHappened = true
	#clear the variable queues
	queuedVariableNames.clear()
	queuedVariableValues.clear()

#function to play dialogue nodes in queue
func play_queue():
	if dialogueQueue.size() > 0:
		for node in dialogueQueue:
			if !doDialogue:
				print("Dialogue node skipped: ", node)
				continue
			DialogueManager.show_balloon(node, dialogue)
			yield(DialogueManager, "dialogue_finished")
	dialogueQueue.clear()
	#signal main that dialogue is finished
	emit_signal("all_dialogue_finished")

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
					{function = "frog_reveal(moveCaptures)", variableNames = ["moveCaptures"], dialogueNode = "frog_reveal", alreadyHappened = false},
					{function = "good_move(moveTeam, moveScore)", variableNames = ["moveTeam", "moveScore"], dialogueNode = "good_move", alreadyHappened = null},
					{function = "ur_mom(turnNumber)", variableNames = ["turnNumber"], dialogueNode = "ur_mom", alreadyHappened = false},
					{function = "uses_both(movePiece, turnNumber)", variableNames = ["movePiece", "turnNumber"], dialogueNode = "uses_both", alreadyHappened = false},
					{function = "white_lost(loser)", variableNames = ["loser"], dialogueNode = "white_lost", alreadyHappened = null},
					{function = "black_lost(loser)", variableNames = ["loser"], dialogueNode = "black_lost", alreadyHappened = null},
					{function = "draw(loser)", variableNames = ["loser"], dialogueNode = "draw", alreadyHappened = null},
					{function = "jail_dialogue(jailedPiece)", variableNames = ["jailedPiece"], dialogueNode = "jail_dialogue", alreadyHappened = null}
																																]
#special case bool functions
func opening_dialogue(turnNumber : int) -> bool:
	if turnNumber == 0:
		return true
	return false
func frog_reveal(moveCaptures : Array) -> bool:
	if moveCaptures.size() > 0:
		if moveCaptures[-1].type == "Hat":
			return true
	return false
func good_move(moveTeam : String, moveScore : float) -> bool:
	if moveTeam == oppenentTeam && moveScore > 15:
		return true
	return false
func ur_mom(turnNumber : int) -> bool:
	if turnNumber == 1:
		return true
	return false
func uses_both(movePiece : Object, turnNumber : int) -> bool:
	if movePiece.type == "Hat" && turnNumber == 3:
		return true
	return false
func jail_dialogue(_jailedPiece):
	return true
func white_lost(loser):
	if loser == "white":
		return true
	return false
func black_lost(loser):
	if loser == "black":
		return true
	return false
func draw(loser):
	if loser == "draw":
		return true
	return false
