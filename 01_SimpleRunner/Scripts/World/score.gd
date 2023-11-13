class_name Score
extends CenterContainer


@onready var score_number_label = $HBoxContainer/ScoreNumberLabel


@export var score = 0.0


func _ready():
	score_number_label.text = "0"


func _process(delta):
	score += delta * 10 * GameData.game_speed_multiplier
	score_number_label.text = str(int(score))
	
