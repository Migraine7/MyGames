class_name Player
extends Participant


@onready var trash_icon = $TrashIcon as Node2D
@onready var use_icon = $UseIcon

# State machine
@onready var state_machine = $StateMachine as StateMachine
@onready var player_idle_state = $StateMachine/PlayerIdleState
@onready var player_turn_state = $StateMachine/PlayerTurnState
@onready var player_draw_two_state = $StateMachine/PlayerDrawTwoState
@onready var player_swap_state = $StateMachine/PlayerSwapState
@onready var player_peek_state = $StateMachine/PlayerPeekState
@onready var player_end_turn_state = $StateMachine/PlayerEndTurnState


enum Location {CARD1 = 0, CARD2, CARD3, CARD4, CARD5, TRASH, USE, NONE}


@export var card_drop_location : Location = Location.NONE
@export var is_card_held : bool = false


var trash_icon_active : bool
var use_icon_active : bool


func _ready():
#	Events.picked_up_egg.connect(state_machine.change_state.bind(game_spawn_chick_state))
	
#	Events.card_dropped.connect(_on_card_dropped)
#	Events.card_picked_up.connect(_on_card_picked_up)
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


#func _on_card_dropped():
#	is_card_held = false
#	trash_icon.visible = false
#	use_icon.visible = false
#	if GlobalVariables.debugging:
#		show_cards()
#
#
#func _on_card_picked_up():
#	is_card_held = true
#	trash_icon.visible = true
#	if is_action_card:
#		use_icon.visible = true


func _on_card_1_detector_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if is_action_card: return
	card_drop_location = Location.CARD1
	card_1.position = card_1.position + Vector2(0, -20)


func _on_card_1_detector_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	card_drop_location = Location.NONE
	card_1.position = card_1.position + Vector2(0, 20)


func _on_card_2_detector_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if is_action_card: return	
	card_drop_location = Location.CARD2
	card_2.position = card_2.position + Vector2(0, -20)
	


func _on_card_2_detector_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	card_drop_location = Location.NONE
	card_2.position = card_2.position + Vector2(0, 20)	


func _on_card_3_detector_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if is_action_card: return
	card_drop_location = Location.CARD3
	card_3.position = card_3.position + Vector2(0, -20)
	


func _on_card_3_detector_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	card_drop_location = Location.NONE
	card_3.position = card_3.position + Vector2(0, 20)


func _on_card_4_detector_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if is_action_card: return
	card_drop_location = Location.CARD4
	card_4.position = card_4.position + Vector2(0, -20)


func _on_card_4_detector_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	card_drop_location = Location.NONE
	card_4.position = card_4.position + Vector2(0, 20)


func _on_card_5_detector_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if is_action_card: return
	card_drop_location = Location.CARD5
	card_5.position = card_5.position + Vector2(0, -20)


func _on_card_5_detector_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	card_drop_location = Location.NONE
	card_5.position = card_5.position + Vector2(0, 20)


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
