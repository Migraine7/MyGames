class_name GameRunningState
extends State


@onready var game_over = $"../../CanvasLayer/GameOver"


func _ready():
	set_physics_process(false)
	game_over.visible = false
	
func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)
