extends Node2D


@onready var state_machine = $StateMachine
@onready var game_running_state = $StateMachine/GameRunningState
@onready var game_spawn_chick_state = $StateMachine/GameSpawnChickState
@onready var game_over_state = $StateMachine/GameOverState


@export var world_scene_path : String


func _ready():
	Events.picked_up_egg.connect(state_machine.change_state.bind(game_spawn_chick_state))
	Events.game_over.connect(state_machine.change_state.bind(game_over_state))

	world_scene_path = scene_file_path


func _process(delta):
	pass
