class_name GameManager
extends Node

# will spawn the player and up to 3 other participants, based on player input
# will manage the turns


@onready var deck = $"../Deck" as Deck

@onready var state_machine = $StateMachine as StateMachine
@onready var start_game_state = $StateMachine/StartGameState
@onready var player_state = $StateMachine/PlayerState
@onready var bot_1_state = $StateMachine/Bot1State
@onready var bot_2_state = $StateMachine/Bot2State
@onready var bot_3_state = $StateMachine/Bot3State


const CARD_PATH = "res://Scenes/card.tscn"
const PLAYER_PATH = "res://Scenes/player.tscn"
const BOT1_PATH = "res://Scenes/bot_1_top.tscn"
const BOT2_PATH = "res://Scenes/bot_2_left.tscn"
const BOT3_PATH = "res://Scenes/bot_3_right.tscn"
const MAX_CARD_STACK_SIZE = 4
const PARTICIPANTS_NUM = 4


var card_scene : PackedScene
var player_scene : PackedScene
var bot1_scene : PackedScene
var bot2_scene : PackedScene
var bot3_scene : PackedScene
var participants : Array
var card_pulled : Card
var thrown_cards : Array[Card]
var player_turn : int = -1
var player_turns_left : int = 0
var card_from_deck : bool = false


func _ready():
	Events.player_turn_end.connect(_on_player_turn_end)
	Events.trash_card.connect(_on_trash_card)
	Events.swapped_card.connect(_on_swapped_card)
	Events.use_card.connect(_on_use_card)
	
	card_scene = preload(CARD_PATH)
	player_scene = preload(PLAYER_PATH)
	bot1_scene = preload(BOT1_PATH)
	bot2_scene = preload(BOT2_PATH)
	bot3_scene = preload(BOT3_PATH)
	
	var player_instance = player_scene.instantiate() as Player
	var bot1_instance = bot1_scene.instantiate() as Participant
	var bot2_instance = bot2_scene.instantiate() as Participant
	var bot3_instance = bot3_scene.instantiate() as Participant
	
	add_child(player_instance)
	add_child(bot1_instance)
	add_child(bot2_instance)
	add_child(bot3_instance)

	participants.append(player_instance)
	participants.append(bot1_instance)
	participants.append(bot2_instance)
	participants.append(bot3_instance)
	
	deal_cards()
	_on_player_turn_end()


func _on_deck_card_pulled(card : GlobalVariables.Cards):
	card_from_deck = true
	card_pulled = card_scene.instantiate()
	add_child(card_pulled)

	change_card_draggable()
	change_stack_pickable(false)
	card_pulled.card_value = card
	var card_sprite = card_pulled.sprite_2d as Sprite2D
	card_sprite.texture = load("res://Assets/cards/" + GlobalVariables.Cards.keys()[card].to_lower() + ".png")
	
	if card > GlobalVariables.Cards.TEN:
		participants[player_turn].is_action_card = true
	

func deal_cards():
	for participant in participants:
		for i in range(5):
			participant.cards.append(deck.get_card())
		
		if GlobalVariables.debugging:
			participant.show_cards()


func _on_trash_card():
	print("trashed card")	
	if thrown_cards.size() == MAX_CARD_STACK_SIZE:
		thrown_cards.front().queue_free()
		thrown_cards.pop_front()
	
	if participants[player_turn].state_machine.state == participants[player_turn].player_draw_two_state:
		card_pulled.pickable = false
	card_pulled.add_to_stack()
	
	if card_from_deck:
		change_stack_pickable(false)
		thrown_cards.append(card_pulled)
	
	reset_participant_vars()
	player_turns_left -= 1


func _on_swapped_card(card_index : int):
	print("swapped card")	
	var player = participants.front() as Participant
	var previous_card_value = player.cards[card_index]
	player.cards[card_index] = card_pulled.card_value
	
	card_pulled.card_value = previous_card_value
	player.show_cards()
	_on_trash_card()
	

func _on_use_card():
	print("used card")
	# Add UI changes
	
	if card_pulled.card_value == GlobalVariables.Cards.DRAW_TWO:
		player_turns_left += 2
	
	elif card_pulled.card_value == GlobalVariables.Cards.PEEK or \
		 card_pulled.card_value == GlobalVariables.Cards.SWAP:
		player_turns_left -= 1
	
	card_pulled.pickable = false
	_on_trash_card()
	
	participants[player_turn].use_action_card(card_pulled.card_value)


func reset_participant_vars():
	participants[player_turn].is_action_card = false


func _on_player_turn_end():
	print("turn end")	
	# Only change player if the player has no turns left, meaning they did not pull a DRAW_TWO card
	if player_turns_left == 0:
		if player_turn >= 0:
			# send current player to an idle state
			participants[player_turn].state_machine.change_state(participants[player_turn].player_idle_state)
		
		player_turn = (player_turn + 1) % PARTICIPANTS_NUM
		player_turns_left = 1
	
	deck.clickable = false
	card_from_deck = false
	if player_turn == 0:
		deck.clickable = true
		state_machine.change_state(player_state)
	elif player_turn == 1:
		state_machine.change_state(bot_1_state)
	elif player_turn == 2:
		state_machine.change_state(bot_2_state)
	elif player_turn == 3:
		state_machine.change_state(bot_3_state)
	
	change_card_draggable()


func change_card_draggable():
	if card_pulled == null: return
	if state_machine.state == player_state:
		card_pulled.set_card_pickup(true)
	else:
		card_pulled.set_card_pickup(false)
		if thrown_cards.size() > 0:
			thrown_cards.back().set_card_pickup(false)


func change_stack_pickable(value: bool):
	if thrown_cards.size() > 0:
		thrown_cards.back().pickable = value
