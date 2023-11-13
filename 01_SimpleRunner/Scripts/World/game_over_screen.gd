extends ColorRect


@onready var score_number_label = $CenterContainer/VBoxContainer/HBoxContainer2/ScoreNumberLabel


@export var final_score : int


signal play_again


func _on_play_again_button_pressed():
	play_again.emit()


func _on_quit_button_pressed():
	get_tree().quit()


func _process(delta):
	if visible and final_score > 0:
		score_number_label.text = str(final_score)
