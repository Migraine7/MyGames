class_name GameOverState
extends State


@onready var game_over = $"../../CanvasLayer/GameOver"
@onready var score_label = $"../../CanvasLayer/GameOver/CenterContainer/VBoxContainer/ScoreLabel"
@onready var score = $"../../CanvasLayer/Score" as Score


func _ready():
	set_physics_process(false)
	
	
func _enter_state() -> void:
	set_physics_process(true)
	game_over.visible = true
	score_label.text = "Score: " + score.get_score_string()
	get_tree().paused = true
	

func _exit_state() -> void:
	set_physics_process(false)


func _on_retry_button_pressed():
	get_tree().paused = false
	Events.game_restart.emit()
	get_tree().reload_current_scene()


func _on_quit_button_pressed():
	get_tree().quit()
