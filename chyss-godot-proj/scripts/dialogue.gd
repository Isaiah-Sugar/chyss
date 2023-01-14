extends Spatial

var dialogue = preload("res://dialogue/test dialogue.tres")
var frogFlag = false

var caseArray = [
					{function = Expression.new().parse("opening_dialogue(turnNumber)", ["turnNumber"]), diaolgueNode = "opening_dialogue", alreadyHappened = false},
					{function = Expression.new().parse("frog_reveal(move)", ["move"]), dialogueNode = "frog_reveal", alreadyHappened = false}
																																]

func determine_dialogue(move, turnNumber):
	for case in caseArray:
		print (case.function)
		if case.function.execute() && !case.alreadyHappened:
			DialogueManager.show_example_dialogue_balloon(case.dialogueNode, dialogue)
			return

func frog_reveal(move):
	if move && move.capture && move.capture.type == "Hat":
		return true
