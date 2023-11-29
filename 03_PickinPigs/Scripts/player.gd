class_name Player
extends Participant


@onready var trash_icon = $TrashIcon as Node2D
@onready var use_icon = $UseIcon
@onready var animation_player = $AnimationPlayer

# State machine
@onready var state_machine = $StateMachine as StateMachine
@onready var player_idle_state = $StateMachine/PlayerIdleState
@onready var player_turn_state = $StateMachine/PlayerTurnState
@onready var player_draw_two_state = $StateMachine/PlayerDrawTwoState
@onready var player_swap_state = $StateMachine/PlayerSwapState
@onready var player_peek_state = $StateMachine/PlayerPeekState
@onready var player_end_turn_state = $StateMachine/PlayerEndTurnState


enum Location {CARD1 = 0, CARD2, CARD3, CARD4, CARD5, TRASH, USE, NONE}


const INITIAL_Y_POS = 512
const DARK_COLOR = Color(0.4, 0.4, 0.4, 1)
const NORMAL_COLOR = Color(1, 1, 1, 1)


@export var card_drop_location : Location = Location.NONE
@export var is_card_held : bool = false


var trash_icon_active : bool
var use_icon_active : bool
var swap_chosen_counter : int = 0


func _ready():
	Events.chose_card.connect(_on_chose_card)
	
	set_trash_icon_active(false)
	set_use_icon_active(false)


func _process(_delta):
	pass
		

func use_action_card(card : GlobalVariables.Cards):
	if card == GlobalVariables.Cards.DRAW_TWO:
		state_machine.change_state(player_draw_two_state)
	elif card == GlobalVariables.Cards.SWAP:
		state_machine.change_state(player_swap_state)
	elif card == GlobalVariables.Cards.PEEK:
		state_machine.change_state(player_peek_state)


func show_card(card_number : int):
	animation_player.play("peek_card_" + str(card_number))
	await animation_player.animation_finished
	
	update_card_sprite(card_number, false)
	animation_player.play("show_card_" + str(card_number))
	await animation_player.animation_finished
	update_card_sprite(card_number, true)
	
	animation_player.play("RESET")
	

func _on_chose_card(_player_index: int, _card_index: int):
	if is_human_player_turn:
		if swap_chosen_counter % 2 == 0:
			pass
		else:
			reset_card_positions()
		swap_chosen_counter += 1


func _on_card_1_detector_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if not is_card_held or is_action_card: return
	card_drop_location = Location.CARD1
	card_1.position = card_1.position + Vector2(0, -20)


func _on_card_1_detector_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	card_drop_location = Location.NONE
	card_1.position.y = INITIAL_Y_POS


func _on_card_2_detector_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if not is_card_held or is_action_card: return	
	card_drop_location = Location.CARD2
	card_2.position = card_2.position + Vector2(0, -20)
	

func _on_card_2_detector_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	card_drop_location = Location.NONE
	card_2.position.y = INITIAL_Y_POS


func _on_card_3_detector_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if not is_card_held or is_action_card: return
	card_drop_location = Location.CARD3
	card_3.position = card_3.position + Vector2(0, -20)
	

func _on_card_3_detector_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	card_drop_location = Location.NONE
	card_3.position.y = INITIAL_Y_POS


func _on_card_4_detector_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if not is_card_held or is_action_card: return
	card_drop_location = Location.CARD4
	card_4.position = card_4.position + Vector2(0, -20)


func _on_card_4_detector_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	card_drop_location = Location.NONE
	card_4.position.y = INITIAL_Y_POS


func _on_card_5_detector_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if not is_card_held or is_action_card: return
	card_drop_location = Location.CARD5
	card_5.position = card_5.position + Vector2(0, -20)


func _on_card_5_detector_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	card_drop_location = Location.NONE
	card_5.position.y = INITIAL_Y_POS


func _on_trash_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if trash_icon_active:
		card_drop_location = Location.TRASH


func _on_trash_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	if trash_icon_active:
		card_drop_location = Location.NONE


func _on_use_card_detector_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if use_icon_active:
		card_drop_location = Location.USE


func _on_use_card_detector_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	if use_icon_active:
		card_drop_location = Location.NONE


func set_trash_icon_active(value: bool):
	trash_icon.visible = value
	trash_icon_active = value
	

func set_use_icon_active(value: bool):
	use_icon.visible = value
	use_icon_active = value
	
	
func end_turn():
	Events.player_turn_end.emit()


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
