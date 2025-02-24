extends Node

var score = 1
@onready var score_label: Label = $Label
 
func add_point():
	score_label.text = "Score: " + str(score)
	score += 1
	print(score)
	
