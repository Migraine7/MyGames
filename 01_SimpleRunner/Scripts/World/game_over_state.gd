class_name GameOverState
extends State


@onready var player = %Player
@onready var game_over_screen = $"../../CanvasLayer/GameOverScreen"
@onready var score = $"../../Pauseable/Score"


var game_over_popup_delay = 1.5


func _ready():
	set_process(false)
	
	
func _enter_state() -> void:
	set_process(true)
	get_tree().paused = true
	

func _exit_state() -> void:
	set_process(false)
#	get_tree().paused = false
	pass


func _process(delta):
	if game_over_popup_delay <= 0.0:
		score.visible = false
		game_over_screen.visible = true
		game_over_screen.final_score = score.score
	else:
		game_over_popup_delay -= delta
