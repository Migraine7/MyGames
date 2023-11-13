class_name Card
extends Node2D


@onready var sprite_2d = $Sprite2D as Sprite2D
@onready var not_pickable_icon = $Sprite2D/NotPickableIcon
@onready var collision_detector = $CollisionDetector
@onready var card_button = $CardButton as TouchScreenButton


@export var pickable : bool = true

const ORIGINAL_POSITION = Vector2(640, 300)
const ORIGINAL_SCALE = Vector2(2.5, 2.5)

var is_dragged : bool = false
var is_in_stack : bool = false
var card_value : GlobalVariables.Cards
var card_button_active : bool = true


func _process(_delta):
	not_pickable_icon.visible = not pickable
	
	if is_dragged:
		sprite_2d.scale = Vector2(1, 1)
		sprite_2d.rotation = 0
		global_position = get_global_mouse_position()
	
	elif not is_in_stack:
		sprite_2d.scale = ORIGINAL_SCALE
		global_position = ORIGINAL_POSITION
	
#	else:
#		reset_card_transform()
		

func add_to_stack():
	sprite_2d.scale = Vector2(1.5, 1.5)
	sprite_2d.rotation = randf_range(-0.3, 0.3)
	sprite_2d.texture = load("res://Assets/cards/" + GlobalVariables.Cards.keys()[card_value].to_lower() + ".png")
	position = ORIGINAL_POSITION	
	is_in_stack = true


func reset_card_transform():
	sprite_2d.scale = Vector2(1.5, 1.5)
	sprite_2d.rotation = 0
	position = ORIGINAL_POSITION	


func _on_card_button_pressed():
	if card_button_active:
		if not is_in_stack or pickable:
			is_dragged = true
			Events.card_picked_up.emit()


func _on_card_button_released():
	if card_button_active:
		if not is_in_stack or pickable:
			is_dragged = false
			Events.card_dropped.emit()
		
		if is_in_stack:
			add_to_stack()
			

func set_card_pickup(value: bool):
	card_button.visible = value
	card_button_active = value
