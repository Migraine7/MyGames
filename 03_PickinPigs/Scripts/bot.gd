class_name Bot
extends Participant

@onready var state_machine = $StateMachine
@onready var player_idle_state = $StateMachine/PlayerIdleState
@onready var player_draw_two_state = $StateMachine/BotPlayerDrawTwoState
@onready var player_turn_state = $StateMachine/BotPlayerTurnState
@onready var player_peek_state = $StateMachine/BotPlayerPeekState
@onready var player_swap_state = $StateMachine/BotPlayerSwapState


@export var top_stack_card: Card


@onready var seen_icon_1 = $Card1/SeenIcon
@onready var seen_icon_2 = $Card2/SeenIcon
@onready var seen_icon_3 = $Card3/SeenIcon
@onready var seen_icon_4 = $Card4/SeenIcon
@onready var seen_icon_5 = $Card5/SeenIcon
@onready var label_1 = $Card1/SeenIcon/Label
@onready var label_2 = $Card2/SeenIcon/Label
@onready var label_3 = $Card3/SeenIcon/Label
@onready var label_4 = $Card4/SeenIcon/Label
@onready var label_5 = $Card5/SeenIcon/Label

@onready var animation_player = $AnimationPlayer


var card_pulled: Card
var is_select_active : bool = false
var last_card_pressed : int = -1
var swap_chosen_counter : int = 0

var cards_seen : Array


const DARK_COLOR = Color(0.4, 0.4, 0.4, 1)
const NORMAL_COLOR = Color(1, 1, 1, 1)
const MAX_PARTICIPANTS = 4


func _ready():
	Events.chose_card.connect(_on_chose_card)
	Events.bot_seen_card.connect(_on_bot_seen_card)
	
	top_stack_card = null
	init_other_cards_seen()


func _process(_delta):
	pass
	

func _on_chose_card(_player_index: int, _card_index: int):
	# If the human player is in the midst of swapping cards, let them pick a card from this bot
	if is_human_player_turn:
		last_card_pressed = -1
		if swap_chosen_counter % 2 == 0:
			is_select_active = true
		else:
			is_select_active = false
			reset_card_positions()
		swap_chosen_counter += 1


func use_action_card(card : GlobalVariables.Cards):
	# Swap states after using an action card
	if card == GlobalVariables.Cards.DRAW_TWO:
		state_machine.change_state(player_draw_two_state)
	elif card == GlobalVariables.Cards.SWAP:
		state_machine.change_state(player_swap_state)
	elif card == GlobalVariables.Cards.PEEK:
		state_machine.change_state(player_peek_state)
		

func darken_cards():
	card_1.self_modulate = DARK_COLOR
	card_2.self_modulate = DARK_COLOR
	card_3.self_modulate = DARK_COLOR
	card_4.self_modulate = DARK_COLOR
	card_5.self_modulate = DARK_COLOR


func highlight_cards():
	card_1.self_modulate = NORMAL_COLOR
	card_2.self_modulate = NORMAL_COLOR
	card_3.self_modulate = NORMAL_COLOR
	card_4.self_modulate = NORMAL_COLOR
	card_5.self_modulate = NORMAL_COLOR


func _on_card_1_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 1:
		is_select_active = false
		last_card_pressed = -1
		Events.chose_card.emit(player_id, 0)
	else:
		last_card_pressed = 1
		move_card_out(last_card_pressed)
		Events.card_moved.emit(player_id)
		

func _on_card_2_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 2:
		is_select_active = false
		last_card_pressed = -1
		Events.chose_card.emit(player_id, 1)
	else:
		last_card_pressed = 2
		move_card_out(last_card_pressed)
		Events.card_moved.emit(player_id)		


func _on_card_3_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 3:
		is_select_active = false
		last_card_pressed = -1
		Events.chose_card.emit(player_id, 2)
	else:
		last_card_pressed = 3
		move_card_out(last_card_pressed)
		Events.card_moved.emit(player_id)		


func _on_card_4_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 4:
		is_select_active = false
		last_card_pressed = -1
		Events.chose_card.emit(player_id, 3)
	else:
		last_card_pressed = 4
		move_card_out(last_card_pressed)
		Events.card_moved.emit(player_id)		
	

func _on_card_5_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 5:
		is_select_active = false
		last_card_pressed = -1
		Events.chose_card.emit(player_id, 4)
	else:
		last_card_pressed = 5
		move_card_out(last_card_pressed)
		Events.card_moved.emit(player_id)		


func init_other_cards_seen():
	# Initialize the cards_seen array
	for i in range(MAX_PARTICIPANTS):
		var participant_cards = []
		for j in range(5):
			participant_cards.append(GlobalVariables.Cards.NONE)
			
		cards_seen.append(participant_cards)


func _on_bot_seen_card(player_index: int, max_card_value: GlobalVariables.Cards, card_index: int):
	# Update the cards seen by this bot
	if player_index == player_id: return
	cards_seen[player_index][card_index] = max_card_value


func debug_this_bot_seen_cards_icon():
	var this_bot_cards_seen = cards_seen[player_id] as Array
	
	seen_icon_1.visible = false
	seen_icon_2.visible = false
	seen_icon_3.visible = false
	seen_icon_4.visible = false
	seen_icon_5.visible = false
	
	if this_bot_cards_seen[0] != GlobalVariables.Cards.NONE: 
		seen_icon_1.visible = true
		label_1.text = str(this_bot_cards_seen[0])
	if this_bot_cards_seen[1] != GlobalVariables.Cards.NONE: 
		seen_icon_2.visible = true
		label_2.text = str(this_bot_cards_seen[1])
	if this_bot_cards_seen[2] != GlobalVariables.Cards.NONE: 
		seen_icon_3.visible = true
		label_3.text = str(this_bot_cards_seen[2])
	if this_bot_cards_seen[3] != GlobalVariables.Cards.NONE: 
		seen_icon_4.visible = true
		label_4.text = str(this_bot_cards_seen[3])
	if this_bot_cards_seen[4] != GlobalVariables.Cards.NONE: 
		seen_icon_5.visible = true
		label_5.text = str(this_bot_cards_seen[4])
