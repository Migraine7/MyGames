class_name GameManager
extends Node

# will spawn the player and up to 3 other participants, based on player input
# will manage the turns


@onready var deck = $"../Deck" as Deck
@onready var main_animation_player = $"../MainAnimationPlayer" as AnimationPlayer
@onready var press_to_start_overlay = $"../PressToStartOverlay"

# State machine
@onready var state_machine = $StateMachine as StateMachine
@onready var start_game_state = $StateMachine/StartGameState
@onready var player_state = $StateMachine/PlayerState
@onready var bot_1_state = $StateMachine/Bot1State
@onready var bot_2_state = $StateMachine/Bot2State
@onready var bot_3_state = $StateMachine/Bot3State

# Used card overlay
@onready var used_card_sprite = $"../UsedCardOverlay/UsedCardSprite"
@onready var used_card_character_sprite = $"../UsedCardOverlay/UsedCardSprite/CharacterSprite"
@onready var used_player_label = $"../UsedCardOverlay/UsedCardSprite/Label"
@onready var used_card_label = $"../UsedCardOverlay/UsedCardSprite/Label2"

# Menu overlay
@onready var canvas_layer_3 = $"../MenuOverlay"
@onready var color_rect = $"../MenuOverlay/ColorRect"
@onready var center_container = $"../MenuOverlay/CenterContainer"

# Bell related
@onready var bell_button = $"../BackgroundOverlay/BellButton"
@onready var bell_label = $"../RangBellOverlay/ColorRect/BellSprite/Label"


const MENU_PATH = "res://Scenes/menu.tscn"
const CARD_PATH = "res://Scenes/card.tscn"
const PLAYER_PATH = "res://Scenes/player.tscn"
const BOT1_PATH = "res://Scenes/bot_1_left.tscn"
const BOT2_PATH = "res://Scenes/bot_2_top.tscn"
const BOT3_PATH = "res://Scenes/bot_3_right.tscn"
const MAX_CARD_STACK_SIZE = 4
const PARTICIPANTS_NUM = 4
const DARK_COLOR = Color(0.4, 0.4, 0.4, 1)
const NORMAL_COLOR = Color(1, 1, 1, 1)


# Scenes
var menu_scene : PackedScene
var card_scene : PackedScene
var player_scene : PackedScene
var bot1_scene : PackedScene
var bot2_scene : PackedScene
var bot3_scene : PackedScene

# Game manager data structures
var participants : Array
var card_pulled : Card
var thrown_cards : Array[Card]

# Game flow variables and flags
var player_turn : int = -1
var player_turns_left : int = 0
var card_from_deck : bool = false
var chosen_swap_card : int = -1
var chosen_swap_player : int = -1
var is_card_moved : bool = false
var card_moved_player : int = -1
var should_animate : bool = true
var is_last_turn : bool = false
var is_muted : bool = false


func _ready():
	# Relevant singals
	Events.player_turn_end.connect(_on_player_turn_end)
	Events.bot_pull_card.connect(_on_bot_pull_card)
	Events.bot_peek_use.connect(_on_bot_peek_use)
	Events.bot_rang_bell.connect(_on_bell_button_pressed)
	Events.trash_card.connect(_on_trash_card)
	Events.swapped_card.connect(_on_swapped_card)
	Events.use_card.connect(_on_use_card)
	Events.card_picked_up.connect(_on_card_picked_up)
	Events.card_dropped.connect(_on_card_dropped)
	Events.chose_card.connect(_on_chose_card)
	Events.card_moved.connect(_on_card_moved)
	
	# Load scenes
	menu_scene = load(MENU_PATH)
	card_scene = preload(CARD_PATH)
	player_scene = preload(PLAYER_PATH)
	bot1_scene = preload(BOT1_PATH)
	bot2_scene = preload(BOT2_PATH)
	bot3_scene = preload(BOT3_PATH)
	
	# Instantiate all the players
	var player_instance = player_scene.instantiate() as Player
	var bot1_instance = bot1_scene.instantiate() as Bot
	var bot2_instance = bot2_scene.instantiate() as Bot
	var bot3_instance = bot3_scene.instantiate() as Bot
	
	add_child(player_instance)
	add_child(bot1_instance)
	add_child(bot2_instance)
	add_child(bot3_instance)

	participants.append(player_instance)
	participants.append(bot1_instance)
	participants.append(bot2_instance)
	participants.append(bot3_instance)
	
	# Initialize important variables
	set_player_ids()
	press_to_start_overlay.visible = true
	SoundManager.animation_player.play("game_music_fade_in")
	bell_button.disabled = true
	deck.clickable = false
	

func _on_deck_card_pulled(card : GlobalVariables.Cards):
	deck.animation_player.play("pull_card")
	SoundManager.play_draw_card_sfx()
	
	# Instantiate a new card
	deck.clickable = false
	card_from_deck = true
	card_pulled = card_scene.instantiate()
	add_child(card_pulled)

	# Update card
	change_card_draggable()
	change_stack_pickable(false)
	card_pulled.card_value = card
	var card_sprite = card_pulled.sprite_2d as Sprite2D
	var card_character_sprite = card_pulled.character_sprite as AnimatedSprite2D
	if player_turn == 0:
		card_sprite.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[card].to_lower() + ".png")
		card_character_sprite.play(GlobalVariables.Cards.keys()[card].to_lower())
	
	if card > GlobalVariables.Cards.TEN:
		participants[player_turn].is_action_card = true
	else:
		participants[player_turn].is_action_card = false
	
	# Check if this is the last turn
	if deck.get_deck_size() == 0:
		if card == GlobalVariables.Cards.DRAW_TWO:
			end_game()
		is_last_turn = true


func deal_cards():
	for participant in participants:
		for i in range(5):
			participant.cards.append(deck.get_card())
		
		if GlobalVariables.debugging:
			participant.show_cards()


func _on_bot_pull_card():
	var card = deck.get_card()
	_on_deck_card_pulled(card)
	var bot = participants[player_turn]
	bot.card_pulled = card_pulled


func _on_bot_peek_use(card_index: int):
	# Update bot's cards seen
	var bot = participants[player_turn] as Bot
	bot.cards_seen[bot.player_id][card_index] = bot.cards[card_index]
	
	# Play animation and end turn
	bot.animation_player.play("peek_card_" + str(card_index + 1))
	await bot.animation_player.animation_finished
	_on_player_turn_end()
	

func _on_trash_card():
	# Animate card if needed. Not needed when it's an action card.
	if card_from_deck and should_animate:
		card_pulled.animation_player.play("trash")
	
	# Update stack
	if thrown_cards.size() == MAX_CARD_STACK_SIZE:
		thrown_cards.front().queue_free()
		thrown_cards.pop_front()
	
	if participants[player_turn].state_machine.state == participants[player_turn].player_draw_two_state:
		card_pulled.pickable = false
	
	# Add to stack with different delays, depending on the player
	if player_turn != 0:
		card_pulled.add_to_stack(true)
	else:
		card_pulled.add_to_stack(false)
	
	if card_from_deck:
		change_stack_pickable(false)
		thrown_cards.append(card_pulled)
		if player_turn != 0:
			participants[player_turn].top_stack_card = card_pulled
		
	reset_participant_vars()
	player_turns_left -= 1


func _on_swapped_card(card_index : int):
	# Animate if it's a bot's turn
	if should_animate:
		card_pulled.animation_player.play("card_to_player_" + str(player_turn) + "_card_" + str(card_index + 1))
	SoundManager.play_swap_card_sfx()
	
	should_animate = false
	var player = participants[player_turn] as Participant

	# Update both cards
	var previous_card_value = player.cards[card_index]
	player.cards[card_index] = card_pulled.card_value
	
	card_pulled.card_value = previous_card_value
	Events.bot_seen_card.emit(player_turn, previous_card_value, card_index)
	
	if GlobalVariables.debugging:
		player.show_cards()
	
	_on_trash_card()
	
	should_animate = true
	await card_pulled.animation_player.animation_finished
	card_pulled.animation_player.play("RESET")
	

func _on_use_card():
	if should_animate:
		card_pulled.animation_player.play("use")
		await card_pulled.animation_player.animation_finished
		
	should_animate = false
	
	if card_pulled.card_value == GlobalVariables.Cards.DRAW_TWO:
		if player_turn == 0:
			deck.clickable = true
		player_turns_left = 3
	
	elif card_pulled.card_value == GlobalVariables.Cards.PEEK or \
		 card_pulled.card_value == GlobalVariables.Cards.SWAP:
		deck.clickable = false
#		player_turns_left += 1
	
	card_pulled.pickable = false
	_on_trash_card()
	
	await play_used_card_animation(card_pulled.card_value)
	
	if deck.deck_size == 0 and card_pulled.card_value == GlobalVariables.Cards.DRAW_TWO:
		return
	
	participants[player_turn].use_action_card(card_pulled.card_value)
	
	if 	card_pulled.card_value == GlobalVariables.Cards.DRAW_TWO and \
		player_turn == 0:
			should_animate = false
	else:
		should_animate = true


func play_used_card_animation(card_value: GlobalVariables.Cards):
	# Set the correct visuals
	used_card_sprite.texture = load("res://Assets/Cards/" + GlobalVariables.Cards.keys()[card_value].to_lower() + ".png")
	used_card_character_sprite.play(GlobalVariables.Cards.keys()[card_value].to_lower())
	used_player_label.text = "PLAYER " + str(player_turn + 1)
	var card_string = str(GlobalVariables.Cards.keys()[card_value].to_upper()) if card_value != GlobalVariables.Cards.DRAW_TWO else "DRAW 2"
	used_card_label.text = "USED " + card_string + "!"
	
	main_animation_player.play("used_card_in")
	await main_animation_player.animation_finished
	


func reset_participant_vars():
	participants[player_turn].is_action_card = false


func _on_player_turn_end():
	# Only change player if the player has no turns left, meaning they did not pull a DRAW_TWO card

	for i in range(PARTICIPANTS_NUM):
		darken_player_cards(i)
	
	if is_last_turn:
		end_game()
		return
		
	if player_turns_left == 0:
		if player_turn >= 0:
			# send current player to an idle state
			participants[player_turn].state_machine.change_state(participants[player_turn].player_idle_state)
		
		player_turn = (player_turn + 1) % PARTICIPANTS_NUM
		player_turns_left = 1
		main_animation_player.play("RESET")
	
	deck.clickable = false
	card_from_deck = false
	highlight_player_cards(player_turn)
	should_animate = true
	bell_button.disabled = true

	# Human player turn next
	if player_turn == 0:
		# Set top stack card as action card for the player
		if card_pulled and card_pulled.card_value > GlobalVariables.Cards.TEN:
			participants[player_turn].is_action_card = true
		deck.clickable = true
		should_animate = false
		bell_button.disabled = false
		
		state_machine.change_state(player_state)
	
	# Bot turn next
	else:
		var bot = participants[player_turn] as Bot
		bot.top_stack_card = card_pulled
		await get_tree().create_timer(2.0).timeout
		
		if player_turn == 1:
			state_machine.change_state(bot_1_state)
		
		elif player_turn == 2:
			state_machine.change_state(bot_2_state)
		
		elif player_turn == 3:
			state_machine.change_state(bot_3_state)
	
	change_card_draggable()


func _on_card_picked_up():
	var player = participants.front()
	player.is_card_held = true
	if card_from_deck:
		player.set_trash_icon_active(true)
	if player.is_action_card:
		player.set_use_icon_active(true)


func _on_card_dropped():
	var player = participants.front()	
	player.is_card_held = false
	player.set_trash_icon_active(false)
	player.set_use_icon_active(false)
	if GlobalVariables.debugging:
		player.show_cards()


func _on_chose_card(player_index: int, card_index: int):
	# First card of the swap pair chosen
	if chosen_swap_card == -1:
		for i in range(PARTICIPANTS_NUM):
			if i == player_index:
				darken_player_cards(i)
			else:
				highlight_player_cards(i)
	
		chosen_swap_card = card_index
		chosen_swap_player = player_index
		
		if player_turn != 0:
			var particiapnt = participants[player_index]
			particiapnt.animation_player.play("chose_card_" + str(card_index + 1))
	
	# Second card of the swap pair chosen
	else:
		var participant1 = participants[chosen_swap_player]
		var participant2 = participants[player_index]
		var temp_card = participant1.cards[chosen_swap_card]
		participant1.cards[chosen_swap_card] = participant2.cards[card_index]
		participant2.cards[card_index] = temp_card
		
		if chosen_swap_player != 0:
			var bot = participant1 as Bot
			bot.cards_seen[chosen_swap_player][chosen_swap_card] = bot.cards[chosen_swap_card]
			
		if player_index != 0:
			var bot = participant2 as Bot
			bot.cards_seen[player_index][card_index] = bot.cards[card_index]
		
		if GlobalVariables.debugging:
			participant1.show_cards()
			participant2.show_cards()		
		
		if player_turn != 0:
			participant2.animation_player.play("chose_card_" + str(card_index + 1))
			await participant2.animation_player.animation_finished
		
		await get_tree().create_timer(2.0).timeout
		participant1.animation_player.play("RESET")
		participant2.animation_player.play("RESET")
		
		var player = participants[0] as Player	
		if player_index == 0:
			highlight_player_cards(0)
			await player.show_card(card_index + 1)
		elif chosen_swap_player == 0:
			highlight_player_cards(0)			
			await player.show_card(chosen_swap_card + 1)

		chosen_swap_card = -1
		is_card_moved = false
		
		_on_player_turn_end()


func _on_card_moved(player_index: int):
	if is_card_moved:
		var participant = participants[card_moved_player] as Participant
		participant.reset_card_positions()
		participant = participants[player_index] as Participant
		participant.move_card_out(participant.last_card_pressed)
	else:
		is_card_moved = true
	
	card_moved_player = player_index
	
	
func end_game():
	# Send player to idle state
	var current_player = participants[player_turn]
	current_player.state_machine.change_state(current_player.player_idle_state)
	await get_tree().create_timer(2.0).timeout
	
	# Block the player from moving the last card or touching the deck
	if card_pulled:
		card_pulled.pickable = false
		card_pulled.add_to_stack()
	deck.clickable = false
	
	# Highlight all cards
	for i in range(PARTICIPANTS_NUM):
		highlight_player_cards(i)
	
	# Flip all participants' cards
	for i in range(PARTICIPANTS_NUM):
		await animate_flip_cards(i)
	
	# Find the winner (or a tie) and update global variables for the end game scene
	var winners = []
	var best_sum = 100
	for participant in participants:
		var participant_score = participant.get_cards_sum()
		if participant_score < best_sum:
			winners = [participant.player_id]
			best_sum = participant_score
		elif participant_score == best_sum:
			winners.append(participant.player_id)
	GlobalVariables.winners = winners
	
	# Make the winners' cards jump around
	for player_id in winners:
		participants[player_id].animation_player.play("win")
	await participants[winners[-1]].animation_player.animation_finished
	
	# Fade out and switch scene to game finished
	main_animation_player.play("fade_out")
	await main_animation_player.animation_finished
	var game_finished_scene = load("res://Scenes/game_finished_overlay.tscn")
	get_tree().change_scene_to_packed(game_finished_scene)
	

func animate_flip_cards(player_id: int):
	var participant = participants[player_id]
	
	# Play first half of flip animation
	participant.animation_player.play("flip_cards_beginning")
	await participant.animation_player.animation_finished
	
	# Update all the card sprites
	participant.update_card_sprite(1, false)
	participant.update_card_sprite(2, false)
	participant.update_card_sprite(3, false)
	participant.update_card_sprite(4, false)
	participant.update_card_sprite(5, false)
	
	# Play second half of flip animation
	participant.animation_player.play("flip_cards_end")
	await participant.animation_player.animation_finished
	

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


func set_player_ids():
	for i in range(PARTICIPANTS_NUM):
		var participant = participants[i] as Participant
		participant.player_id = i


func darken_player_cards(player_index: int):
	participants[player_index].card_1.self_modulate = DARK_COLOR
	participants[player_index].card_2.self_modulate = DARK_COLOR
	participants[player_index].card_3.self_modulate = DARK_COLOR
	participants[player_index].card_4.self_modulate = DARK_COLOR
	participants[player_index].card_5.self_modulate = DARK_COLOR
	

func highlight_player_cards(player_index: int):
	participants[player_index].card_1.self_modulate = NORMAL_COLOR
	participants[player_index].card_2.self_modulate = NORMAL_COLOR
	participants[player_index].card_3.self_modulate = NORMAL_COLOR
	participants[player_index].card_4.self_modulate = NORMAL_COLOR
	participants[player_index].card_5.self_modulate = NORMAL_COLOR


func _on_back_button_pressed():
	# Show sub-menu
	get_tree().paused = true
	canvas_layer_3.visible = true
	

func _on_resume_button_pressed():
	get_tree().paused = false
	canvas_layer_3.visible = false


func _on_menu_button_pressed():
	main_animation_player.play("fade_out")
	SoundManager.animation_player.play("game_music_fade_out")
	get_tree().paused = false
	await SoundManager.animation_player.animation_finished
	get_tree().change_scene_to_packed(menu_scene)


func _on_sound_button_pressed():
	if is_muted:
		SoundManager.game_music.volume_db = SoundManager.GAME_MUSIC_VOLUME
	else:
		SoundManager.game_music.volume_db = SoundManager.MUTE_VOLUME
	
	is_muted = not is_muted		
	

func _on_bell_button_pressed():
	bell_button.disabled = true
	bell_label.text = "PLAYER " + str(player_turn + 1)
	main_animation_player.play("rang_bell")
	SoundManager.play_ring_bell_sfx()
	end_game()
	
