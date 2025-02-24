extends Camera2D
@onready var score_label: Label = $"../../GameManager/Label"
@onready var label: Label = $Label


func _process(delta: float) -> void:
	if score_label.text:
		label.text = score_label.text
	else:
		label.text = "Score: 0"
