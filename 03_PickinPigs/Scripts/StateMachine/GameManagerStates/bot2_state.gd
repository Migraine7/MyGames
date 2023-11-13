class_name Bot2State
extends State


@onready var game_manager = $"../.." as GameManager


func _enter_state():
	var bot = game_manager.participants[2] as Bot
	bot.state_machine.change_state(bot.player_turn_state)
	

func _exit_state():
	var bot = game_manager.participants[2] as Bot
	bot.state_machine.change_state(bot.player_idle_state)
