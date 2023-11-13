class_name Bot
extends Participant


@onready var state_machine = $StateMachine
@onready var player_idle_state = $StateMachine/PlayerIdleState
@onready var player_draw_two_state = $StateMachine/BotPlayerDrawTwoState
@onready var player_turn_state = $StateMachine/BotPlayerTurnState
@onready var player_peek_state = $StateMachine/BotPlayerPeekState
@onready var player_swap_state = $StateMachine/BotPlayerSwapState


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
