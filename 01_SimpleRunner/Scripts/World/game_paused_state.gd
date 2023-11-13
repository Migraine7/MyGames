class_name GamePausedState
extends State


@onready var start_screen = $"../../CanvasLayer/StartScreen"


func _enter_state() -> void:
	set_process(true)
	get_tree().paused = true
	

func _exit_state() -> void:
	set_process(false)
	get_tree().paused = false


func _process(delta):
	if Input.is_anything_pressed():
		Events.game_started.emit()
		start_screen.visible = false
