extends Node


const EGG_PATH = "res://Scenes/egg.tscn"


var egg_scene : PackedScene
var min_egg_spawn_delay : float = 3.0
var max_egg_spawn_delay : float = 7.0
var current_time : float
var rng = RandomNumberGenerator.new()


func _ready():
	Events.game_restart.connect(_on_game_restart)
	
	egg_scene = preload(EGG_PATH)
	current_time = min_egg_spawn_delay
	

func _process(delta):
	if current_time <= 0.0:
		# Spawn new egg
		var egg_instance = egg_scene.instantiate()
		add_child(egg_instance)
		
		# Set egg position
		var max_spawn_attempts = 5
		while max_spawn_attempts > 0:
			var egg_x_grid = rng.randi_range(0, GameData.map_size - 1)
			var egg_y_grid = rng.randi_range(0, GameData.map_size - 1)
			if GameManager.game_tile_map[egg_x_grid][egg_y_grid] == GameManager.TileState.FREE:
				GameManager.game_tile_map[egg_x_grid][egg_y_grid] = GameManager.TileState.EGG
				var new_egg_position = Vector2(egg_x_grid, egg_y_grid) * GameData.tile_size + GameData.position_offset
				egg_instance.global_position = new_egg_position
				break
			max_spawn_attempts -= 1
		
		# If can't spawn an egg then free and wait for the next attempt
		if max_spawn_attempts == 0:
			egg_instance.queue_free()
	
		current_time = rng.randf_range(min_egg_spawn_delay, max_egg_spawn_delay)
	else:
		current_time -= delta
	
	
func _on_game_restart():
	var eggs = get_children()
	for i in range(eggs.size() - 1, -1, -1):
		eggs[i].queue_free()
