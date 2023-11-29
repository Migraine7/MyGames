class_name Participant
extends Node2D


@export var cards : Array[GlobalVariables.Cards]
@export var is_action_card : bool = false
@export var is_human_player_turn: bool = false
@export var player_id : int


@onready var card_1 = $Card1 as Sprite2D
@onready var card_2 = $Card2 as Sprite2D
@onready var card_3 = $Card3 as Sprite2D
@onready var card_4 = $Card4 as Sprite2D
@onready var card_5 = $Card5 as Sprite2D

@onready var character_sprite_1 = $Card1/CardSelectButton/CharacterSprite as AnimatedSprite2D
@onready var character_sprite_2 = $Card2/CardSelectButton/CharacterSprite as AnimatedSprite2D
@onready var character_sprite_3 = $Card3/CardSelectButton/CharacterSprite as AnimatedSprite2D
@onready var character_sprite_4 = $Card4/CardSelectButton/CharacterSprite as AnimatedSprite2D
@onready var character_sprite_5 = $Card5/CardSelectButton/CharacterSprite as AnimatedSprite2D



const INITIAL_CARD_POS = [[Vector2(270, 512), Vector2(422, 512), Vector2(574, 512), Vector2(726, 512), Vector2(878, 512)], \
						  [Vector2(-32, 72), Vector2(-32, 160), Vector2(-32, 248), Vector2(-32, 336), Vector2(-32, 424)], \
						  [Vector2(420, -32), Vector2(508, -32), Vector2(596, -32), Vector2(684, -32), Vector2(772, -32)], \
						  [Vector2(1312, 72), Vector2(1312, 160), Vector2(1312, 248), Vector2(1312, 336), Vector2(1312, 424)]]

const MOVE_VECTOR = [Vector2(0, -20), Vector2(20, 0), Vector2(0, 20), Vector2(-20, 0)]

func _init():
	player_id = -1
	

func show_cards():
	card_1.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[cards[0]].to_lower() + ".png")
	character_sprite_1.play(GlobalVariables.Cards.keys()[cards[0]].to_lower())
	card_2.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[cards[1]].to_lower() + ".png")
	character_sprite_2.play(GlobalVariables.Cards.keys()[cards[1]].to_lower())	
	card_3.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[cards[2]].to_lower() + ".png")
	character_sprite_3.play(GlobalVariables.Cards.keys()[cards[2]].to_lower())	
	card_4.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[cards[3]].to_lower() + ".png")
	character_sprite_4.play(GlobalVariables.Cards.keys()[cards[3]].to_lower())	
	card_5.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[cards[4]].to_lower() + ".png")
	character_sprite_5.play(GlobalVariables.Cards.keys()[cards[4]].to_lower())	


func update_card_sprite(card_number: int, to_hide: bool):
	if card_number == 1:
		if to_hide:
			card_1.texture = load("res://Assets/Cards/hidden.png")
			character_sprite_1.play("hidden")
		else:
			card_1.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[cards[0]].to_lower() + ".png")
			character_sprite_1.play(GlobalVariables.Cards.keys()[cards[0]].to_lower())
	elif card_number == 2:
		if to_hide:
			card_2.texture = load("res://Assets/Cards/hidden.png")
			character_sprite_2.play("hidden")
		else:
			card_2.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[cards[1]].to_lower() + ".png")
			character_sprite_2.play(GlobalVariables.Cards.keys()[cards[1]].to_lower())	
	elif card_number == 3:
		if to_hide:
			card_3.texture = load("res://Assets/Cards/hidden.png")
			character_sprite_3.play("hidden")
		else:
			card_3.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[cards[2]].to_lower() + ".png")
			character_sprite_3.play(GlobalVariables.Cards.keys()[cards[2]].to_lower())	
	elif card_number == 4:
		if to_hide:
			card_4.texture = load("res://Assets/Cards/hidden.png")
			character_sprite_4.play("hidden")
		else:
			card_4.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[cards[3]].to_lower() + ".png")
			character_sprite_4.play(GlobalVariables.Cards.keys()[cards[3]].to_lower())	
	elif card_number == 5:
		if to_hide:
			card_5.texture = load("res://Assets/Cards/hidden.png")
			character_sprite_5.play("hidden")
		else:
			card_5.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[cards[4]].to_lower() + ".png")
			character_sprite_5.play(GlobalVariables.Cards.keys()[cards[4]].to_lower())		
	

func reset_card_positions():
	card_1.position = INITIAL_CARD_POS[player_id][0]
	card_2.position = INITIAL_CARD_POS[player_id][1]
	card_3.position = INITIAL_CARD_POS[player_id][2]
	card_4.position = INITIAL_CARD_POS[player_id][3]
	card_5.position = INITIAL_CARD_POS[player_id][4]


func move_card_out(card_index: int, should_reset_first: bool = true):
	if should_reset_first:
		reset_card_positions()
	if card_index == 1: card_1.position += MOVE_VECTOR[player_id]
	elif card_index == 2: card_2.position += MOVE_VECTOR[player_id]
	elif card_index == 3: card_3.position += MOVE_VECTOR[player_id]
	elif card_index == 4: card_4.position += MOVE_VECTOR[player_id]
	elif card_index == 5: card_5.position += MOVE_VECTOR[player_id]


func slow_end_turn():
	Events.player_turn_end.emit()


func get_cards_sum() -> int:
	var sum = 0
	for card in cards:
		if card > GlobalVariables.Cards.TEN:
			sum += 11
		else:
			sum += card
	return sum
