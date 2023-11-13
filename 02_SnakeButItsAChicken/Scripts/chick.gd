class_name Chick
extends CharacterBody2D


@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D
@onready var entity_shape = $EntityShape


@export var entity_data : EntityData


var current_position : Vector2
var is_skipped_first_move : bool = false


func _ready():
	entity_data = EntityData.new()
	var tmp_entity_data = EntityManager.get_before_last_entity_data()
	entity_data.entity_current_direction = Vector2.ZERO
	entity_data.entity_last_direction = Vector2.ZERO
	entity_data.entity_grid_position = tmp_entity_data.entity_grid_position
#	visible = false


func move(direction):
	if not is_skipped_first_move:
#		visible = true
		update_position(Vector2.ZERO)
		animated_sprite_2d.play("hatch", GameData.game_speed_multiplier)
		is_skipped_first_move = true
		return
	
	# Chick starts as invisible for the first cycle of its life
#	visible = true
	
	var move_direction : Vector2
	move_direction = entity_data.entity_current_direction if not direction else direction
		
	if move_direction.y == 1:
		animated_sprite_2d.play("walk_down", GameData.game_speed_multiplier)
	elif move_direction.y == -1:
		animated_sprite_2d.play("walk_up", GameData.game_speed_multiplier)
	elif move_direction.x == -1:
		animated_sprite_2d.play("walk_left", GameData.game_speed_multiplier)
	elif move_direction.x == 1:
		animated_sprite_2d.play("walk_right", GameData.game_speed_multiplier)

	update_position(move_direction)
	

func update_position(move_direction):
	entity_data.entity_last_direction = entity_data.entity_current_direction
	entity_data.entity_current_direction = move_direction
	entity_data.entity_grid_position += move_direction
	current_position = entity_data.entity_grid_position * GameData.tile_size + GameData.position_offset
	position = current_position
