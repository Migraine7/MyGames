class_name BotPlayerDrawTwoState
extends State


@onready var state_machine = $".." as StateMachine
@onready var bot_player_turn_state = $"../BotPlayerTurnState"



func _ready():
	set_process(false)


func _enter_state():
	state_machine.change_state(bot_player_turn_state)


func _exit_state():
	pass
