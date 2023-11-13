extends Node2D


@onready var player = %Player as Player
@onready var game_over_screen = $CanvasLayer/GameOverScreen
@onready var audio_stream_player_2d = $AudioStreamPlayer2D as AudioStreamPlayer2D


# State Machine
@onready var state_machine = $StateMachine as StateMachine
@onready var game_paused_state = $StateMachine/GamePausedState as GamePausedState
@onready var game_playing_state = $StateMachine/GamePlayingState as GamePlayingState
@onready var game_over_state = $StateMachine/GameOverState as GameOverState


func _ready():
	Events.game_started.connect(state_machine.change_state.bind(game_playing_state))
	Events.game_over.connect(state_machine.change_state.bind(game_over_state))
	
	game_over_screen.visible = false

func _on_game_over_screen_play_again():
	get_tree().change_scene_to_file(scene_file_path)
