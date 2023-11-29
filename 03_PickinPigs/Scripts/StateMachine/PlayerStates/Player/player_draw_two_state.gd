class_name PlayerDrawTwoState
extends State


@onready var state_machine = $".." as StateMachine
@onready var player_turn_state = $"../PlayerTurnState"


func _ready():
	set_process(false)


func _enter_state():
	state_machine.change_state(player_turn_state)


func _exit_state():
	pass
