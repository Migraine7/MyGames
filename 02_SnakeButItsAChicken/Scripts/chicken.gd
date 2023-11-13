class_name Chicken
extends CharacterBody2D


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var entity_shape = $EntityShape


@export var entity_data : EntityData


var current_position : Vector2
var current_direction : Vector2 = GameData.starting_direction
var max_changed_direction : int = 2
var changed_direction_counter : int = 0


func _ready():
	Events.warn_speed_up.connect(_on_warn_speed_up)
	
#	animated_sprite_2d.play("walk_right", GameData.game_speed_multiplier)
#	entity_data.entity_grid_position = Vector2(6, 6)
#	entity_data.entity_current_direction = current_direction
#	entity_data.entity_last_direction = current_direction
#	global_position = entity_data.entity_grid_position * GameData.tile_size + GameData.position_offset
#	current_position = global_position
	
	reset_position()
	
func _physics_process(delta):
	if changed_direction_counter < max_changed_direction:
		if Input.is_action_just_pressed("move_down"):
			Events.chicken_moved.emit(Vector2(0, 1))
			changed_direction_counter += 1
		elif Input.is_action_just_pressed("move_up"):
			Events.chicken_moved.emit(Vector2(0, -1))
			changed_direction_counter += 1		
		elif Input.is_action_just_pressed("move_left"):
			Events.chicken_moved.emit(Vector2(-1, 0))
			changed_direction_counter += 1		
		elif Input.is_action_just_pressed("move_right"):
			Events.chicken_moved.emit(Vector2(1, 0))
			changed_direction_counter += 1		


func move(direction):
	var move_direction : Vector2
	move_direction = current_direction if not direction else direction
		
	update_direction(move_direction)
	update_position(move_direction)
	changed_direction_counter = 0


func update_direction(move_direction):
	if move_direction.y == 1:
		animated_sprite_2d.play("walk_down", GameData.game_speed_multiplier)
	elif move_direction.y == -1:
		animated_sprite_2d.play("walk_up", GameData.game_speed_multiplier)
	elif move_direction.x == -1:
		animated_sprite_2d.play("walk_left", GameData.game_speed_multiplier)
	elif move_direction.x == 1:
		animated_sprite_2d.play("walk_right", GameData.game_speed_multiplier)


func update_position(move_direction):
	entity_data.entity_last_direction = entity_data.entity_current_direction
	entity_data.entity_current_direction = move_direction
	entity_data.entity_grid_position += move_direction
	current_position = entity_data.entity_grid_position * GameData.tile_size + GameData.position_offset
	global_position = current_position


func _on_warn_speed_up():
	animation_player.play("speedup")


func reset_position():
	animated_sprite_2d.play("walk_right", GameData.game_speed_multiplier)
	entity_data.entity_grid_position = GameData.starting_position
	entity_data.entity_current_direction = GameData.starting_direction
	entity_data.entity_last_direction = GameData.starting_direction
	global_position = entity_data.entity_grid_position * GameData.tile_size + GameData.position_offset
	current_position = global_position
	changed_direction_counter = 0
