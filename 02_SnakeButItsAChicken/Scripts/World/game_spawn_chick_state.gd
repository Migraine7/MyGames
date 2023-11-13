class_name GameSpawnChickState
extends State


@onready var state_machine = $".."
@onready var game_running_state = $"../GameRunningState"


func _ready():
	pass
	
func _enter_state() -> void:
	await EntityManager._on_picked_up_egg()
	state_machine.change_state(game_running_state)

func _exit_state() -> void:
	pass
