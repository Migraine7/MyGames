class_name EnemySpawner
extends Node


# Currently there is only one enemy. For more enemies, the script would have to include
# more paths.
const FROG_ENEMY_PATH = "res://Scenes/enemy.tscn"
const MAX_ENEMY_WIDTH = 30
const MAX_ENEMIES_PER_GROUP = 4
const SPAWN_Y = 227
const SPAWN_X = 501


var enemy_scene : PackedScene
var enemies_array : Array
var min_time_until_spawn = 2.5
var current_time_until_spawn : float
var max_enemies_per_spawn : int = 1
var rng = RandomNumberGenerator.new()


func _ready():
	# Preload the enemy scene, that will be used to instantiate new enemies
	enemy_scene = preload(FROG_ENEMY_PATH)
	
	enemies_array = []
	current_time_until_spawn = rng.randf_range(min_time_until_spawn, 2 * min_time_until_spawn)
	
	Events.level_up.connect(_on_level_up)


func _process(delta):
	# Spawn enemies
	if current_time_until_spawn <= 0.0:
		current_time_until_spawn = rng.randf_range(min_time_until_spawn, 3 * min_time_until_spawn) / GameData.enemy_spawn_timer_multiplier
		var enemies_to_spawn = rng.randi_range(1, max_enemies_per_spawn)
		
		for i in range(enemies_to_spawn):
			# Spawn enemy
			var enemy_instance = enemy_scene.instantiate()
			add_child(enemy_instance)
			enemies_array.append(enemy_instance)
			
			# Set enemy position
			enemy_instance.position += Vector2(SPAWN_X + i * MAX_ENEMY_WIDTH, SPAWN_Y)
	else:
		current_time_until_spawn -= delta

	# Free enemies that left the screen
	var first_enemy = enemies_array.front() if enemies_array else null
	if first_enemy and first_enemy.position.x < -MAX_ENEMY_WIDTH:
		first_enemy.queue_free()
		enemies_array.pop_front()


func _on_level_up():
	max_enemies_per_spawn = min(GameData.game_speed_multiplier, MAX_ENEMIES_PER_GROUP)
