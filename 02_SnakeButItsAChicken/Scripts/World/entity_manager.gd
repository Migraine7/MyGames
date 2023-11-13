extends Node


@export var entities_array : Array # Holds Entity nodes (Chicken and Chick)


const CHICKEN_PATH = "res://Scenes/chicken.tscn"
const CHICK_PATH = "res://Scenes/chick.tscn"


var chicken_scene : PackedScene
var chick_scene : PackedScene
var chicken_direction : Array = [GameData.starting_direction]


func _ready():
	# Connect to signals
	Events.update_frames.connect(_on_update_frames)
	Events.chicken_moved.connect(_on_chicken_moved)
	Events.game_restart.connect(_on_game_restart)
	
	# Preload the scenes, that will be used to instantiate new entities
	chicken_scene = preload(CHICKEN_PATH)
	chick_scene = preload(CHICK_PATH)
	
	entities_array = []
	
	var chicken_instance = chicken_scene.instantiate()
	add_child(chicken_instance)
	entities_array.append(chicken_instance)
	

func _on_chicken_moved(new_direction : Vector2):
	chicken_direction.append(new_direction)
		

func _on_update_frames():
	# If the player moves the chicken at least once during the update period, we need to remove
	# the default movement direction 
	if chicken_direction.size() > 1:
		chicken_direction.pop_front()
	
	if check_out_of_bounds() or check_collision():
		# Update chicken direction on death
		entities_array.front().update_direction(chicken_direction.front())
		
		Events.game_over.emit()
		return
	
	var last_direction = chicken_direction.pop_front() if chicken_direction.size() > 1 else chicken_direction[0]
	for i in range(entities_array.size()):
		# Free the tile
		var entity_grid_position = entities_array[i].entity_data.entity_grid_position
		GameManager.game_tile_map[entity_grid_position.x][entity_grid_position.y] = GameManager.TileState.FREE

		# Move the entity
		if i != 0:
			last_direction = entities_array[i-1].entity_data.entity_last_direction
		entities_array[i].move(last_direction)

		# Fill the new tile
		entity_grid_position = entities_array[i].entity_data.entity_grid_position
		GameManager.game_tile_map[entity_grid_position.x][entity_grid_position.y] = GameManager.TileState.ENTITY
	
	update_entity_shape()
		

func _on_picked_up_egg():
	# Instantiate a new chick
	var chick_instance = chick_scene.instantiate()
	call_deferred("add_child", chick_instance)
	entities_array.append(chick_instance)


func check_out_of_bounds() -> bool:
	var chicken_grid_position = entities_array[0].entity_data.entity_grid_position
	if GameManager.check_tile_out_of_bounds(chicken_grid_position + chicken_direction[0]):
		return true
	return false


func check_collision() -> bool:
	var chicken_grid_position = entities_array[0].entity_data.entity_grid_position
	if GameManager.check_can_enter_tile(chicken_grid_position + chicken_direction[0]):
		return false
	return true


func get_before_last_entity_data() -> EntityData:
	if entities_array.size() >= 2:
		return entities_array[-2].entity_data
	else:
		return entities_array[-1].entity_data


func update_entity_shape():
	var last_entity_pos = null
	for i in range(entities_array.size() - 1, -1, -1):
		var entity_pos = entities_array[i].entity_data.entity_grid_position
		var next_entity_pos
		
		if i-1 < 0:
			next_entity_pos = null
		else:
			next_entity_pos = entities_array[i-1].entity_data.entity_grid_position
		
		var shape_string = get_shape_string(last_entity_pos, entity_pos, next_entity_pos)
		entities_array[i].entity_shape.play(shape_string)
		
		last_entity_pos = entity_pos
		
		
func get_shape_string(last_entity_pos, current_entity_pos, next_entity_pos) -> String:
	var direction
	
	if not last_entity_pos:
		# Current entity is the last one
		if not next_entity_pos:
			# Current entity is the lonly one
			return "single"
		
		direction = next_entity_pos - current_entity_pos
	else:
		if not next_entity_pos:
			# Entity is first (chicken)
			direction = last_entity_pos - current_entity_pos
		else:
			# Entity is between two other entities
			var direction_next = next_entity_pos - current_entity_pos
			var direction_last = last_entity_pos - current_entity_pos
			direction = direction_last + direction_next
			if direction_last == -direction_next:
				direction = 2 * direction_last
		
	if direction == Vector2(1, 0):
		return "right"
	elif direction == Vector2(-1, 0):
		return "left"
	elif direction == Vector2(0, 1):
		return "down"
	elif direction == Vector2(0, -1):
		return "up"
	elif direction == Vector2(-1, 1):
		return "left_down"
	elif direction == Vector2(-1, -1):
		return "left_up"
	elif direction == Vector2(1, 1):
		return "right_down"
	elif direction == Vector2(1, -1):
		return "right_up"
	elif abs(direction.x) == 2:
		return "right_left"
	elif abs(direction.y) == 2:
		return "up_down"
	
	return "nothing"


func _on_game_restart():
	# Free existing chicks
	for i in range(entities_array.size() - 1, 0, -1):
		var entity = entities_array[i]
		entity.queue_free()
		entities_array.pop_back()
	
	# Set chicken back to starting position
	var chicken = entities_array.front() as Chicken
	chicken.reset_position()
	chicken_direction = [GameData.starting_direction]
