extends Node


@export var update_timer : float = 0.8
@export var game_start_speed_multiplier : float = 1.5
@export var game_speed_multiplier : float = 1.5
@export var max_game_speed_multiplier : float = 6.5
@export var updates_before_speedup : int = 60
@export var map_size : int = 12
@export var tile_size : int = 18
@export var position_offset : Vector2 = Vector2(221, 90)
@export var starting_position : Vector2 = Vector2(6, 6)
@export var starting_direction : Vector2 = Vector2(1, 0)


func _ready():
	Events.game_restart.connect(_on_game_restart)


func _on_game_restart():
	game_speed_multiplier = game_start_speed_multiplier
