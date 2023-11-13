class_name StateMachine
extends Node


@export var state : State


func _ready():
	change_state(state)


func change_state(new_state: State):
	if new_state is State:
		state._exit_state()
	
	new_state._enter_state()
	state = new_state