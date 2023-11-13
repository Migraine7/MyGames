class_name PlayerState
extends State


@onready var game_manager = $"../.." as GameManager


func _enter_state():
	var player = game_manager.participants[0] as Player
	player.state_machine.change_state(player.player_turn_state)
	

func _exit_state():
	var player = game_manager.participants[0] as Player
	player.state_machine.change_state(player.player_idle_state)
