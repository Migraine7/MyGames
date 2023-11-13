class_name Score
extends HBoxContainer


@onready var score_number_label = $ScoreNumberLabel


const SCORE_PER_EGG = 10


var score : int 


func _ready():
	Events.picked_up_egg.connect(_on_picked_up_egg)
	Events.game_over.connect(_on_game_over)
	Events.game_restart.connect(_on_game_restart)


func get_score_string():
	return str(score)


func _on_picked_up_egg():
	score += SCORE_PER_EGG
	score_number_label.text = str(score)


func _on_game_over():
	visible = false


func _on_game_restart():
	score = 0
