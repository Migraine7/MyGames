extends Node


@export var game_speed_multiplier = 1.0
@export var enemy_spawn_timer_multiplier = 1.0


func _ready():
	Events.level_up.connect(_on_level_up)
	Events.game_over.connect(_on_game_over)


func _on_level_up():
	if game_speed_multiplier < 8:
		game_speed_multiplier *= 1.3
	if enemy_spawn_timer_multiplier < 4:
		enemy_spawn_timer_multiplier *= 1.1


func _on_game_over():
	game_speed_multiplier = 1.0
	enemy_spawn_timer_multiplier = 1.0
