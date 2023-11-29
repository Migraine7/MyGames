class_name PlayerState
extends State


@onready var game_manager = $"../.." as GameManager


func _enter_state():
	set_human_player_turn(true)
	var player = game_manager.participants[0] as Player
	player.state_machine.change_state(player.player_turn_state)
	

func _exit_state():
	set_human_player_turn(false)
	var player = game_manager.participants[0] as Player
	player.state_machine.change_state(player.player_idle_state)


func set_human_player_turn(value: bool):
	for i in range(0, game_manager.PARTICIPANTS_NUM):
		var participant = game_manager.participants[i] as Participant
		participant.is_human_player_turn = value
		
