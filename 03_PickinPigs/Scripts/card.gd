class_name Card
extends Node2D


@onready var sprite_2d = $Sprite2D as Sprite2D
@onready var not_pickable_icon = $Sprite2D/NotPickableIcon
@onready var collision_detector = $CollisionDetector
@onready var card_button = $CardButton as TouchScreenButton
@onready var animation_player = $AnimationPlayer
@onready var character_sprite = $Sprite2D/CharacterSprite


@export var pickable : bool = true

const ORIGINAL_POSITION = Vector2(640, 300)
const ORIGINAL_SCALE = Vector2(2.5, 2.5)

var is_dragged : bool = false
var is_in_stack : bool = false
var card_value : GlobalVariables.Cards
var card_button_active : bool = true
var card_position_timer : float = 0.01

	
func _process(delta):
	not_pickable_icon.visible = not pickable
	
	# Player is holding the card, so follow their mouse
	if is_dragged:
		sprite_2d.scale = Vector2(1, 1)
		sprite_2d.rotation = 0
		global_position = get_global_mouse_position()
	
	# Reset the card's position
	elif not is_in_stack:
		card_position_timer -= delta
		if card_position_timer <= 0:
			sprite_2d.scale = ORIGINAL_SCALE
			global_position = ORIGINAL_POSITION
			card_position_timer = 0.01
		

func add_to_stack(delay_sprite: bool = false):
	# Add the card to the stack
	sprite_2d.scale = Vector2(1.5, 1.5)
	sprite_2d.rotation = randf_range(-0.3, 0.3)
	position = ORIGINAL_POSITION	
	is_in_stack = true
	
	# Update the card's sprite
	if delay_sprite:
		await get_tree().create_timer(2.05).timeout
	sprite_2d.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[card_value].to_lower() + ".png")
	character_sprite.play(GlobalVariables.Cards.keys()[card_value].to_lower())


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
