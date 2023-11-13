extends Node


enum TileState {FREE, ENTITY, EGG}


@export var game_tile_map : Array # 2D Array


var current_update_timer : float
var update_counter : int


func _ready():
	Events.game_restart.connect(_on_game_restart)
	
#	current_update_timer = GameData.update_timer / GameData.game_start_speed_multiplier
#
#	# Initialize game map
#	for i in range(GameData.map_size):
#		game_tile_map.append([])
#		for j in range(GameData.map_size):
#			game_tile_map[i].append(TileState.FREE)

	_on_game_restart()


func _process(delta):
	if current_update_timer <= 0.0:
		current_update_timer = GameData.update_timer / GameData.game_speed_multiplier
		
		# Speed up the game every X number of updates
		if GameData.game_speed_multiplier < GameData.max_game_speed_multiplier and update_counter == 0:
			update_counter = GameData.updates_before_speedup
			GameData.game_speed_multiplier += 1.0
			Events.speed_up.emit()
		else:
			update_counter -= 1
			
		# Two update cycles prior to speedup, emit a signal to warn the player
		if GameData.game_speed_multiplier != GameData.max_game_speed_multiplier and update_counter == 2:
			Events.warn_speed_up.emit()
			
		Events.update_frames.emit()
	else:
		current_update_timer -= delta


func check_tile_out_of_bounds(grid_position : Vector2) -> bool:
	if  grid_position.x >= GameData.map_size \
		or grid_position.x < 0 \
		or grid_position.y >= GameData.map_size \
		or grid_position.y < 0 :
		return true
	return false
	
	
func check_is_tile_free(grid_position : Vector2) -> bool:
	if game_tile_map[grid_position.x][grid_position.y] == TileState.FREE:
		return true
	return false
	

func check_can_enter_tile(grid_position : Vector2) -> bool:
	if not game_tile_map[grid_position.x][grid_position.y] == TileState.ENTITY:
		return true
	return false


func _on_game_restart():
	# Reset game state
	
	current_update_timer = GameData.update_timer / GameData.game_start_speed_multiplier
	
	# Initialize game map
	game_tile_map = []
	for i in range(GameData.map_size):
		game_tile_map.append([])
		for j in range(GameData.map_size):
			game_tile_map[i].append(TileState.FREE)
	
	update_counter = GameData.updates_before_speedup
