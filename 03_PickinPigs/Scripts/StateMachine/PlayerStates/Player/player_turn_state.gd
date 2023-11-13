class_name PlayerTurnState
extends State


@onready var player = $"../.."


const NORMAL_COLOR = Color(1, 1, 1, 1)


func _ready():
	Events.card_dropped.connect(_on_card_dropped)
	Events.card_picked_up.connect(_on_card_picked_up)
	set_process(false)


func _enter_state():
	set_process(true)
	highlight_cards()


func _exit_state():
	set_process(false)


func _process(_delta):
	if not player.is_card_held:
		if player.card_drop_location == player.Location.TRASH:
			Events.trash_card.emit()
			Events.player_turn_end.emit()			
		elif player.card_drop_location == player.Location.USE:
			Events.use_card.emit()
			Events.player_turn_end.emit()			
		elif player.card_drop_location != player.Location.NONE:
			Events.swapped_card.emit(player.card_drop_location)
			Events.player_turn_end.emit()			

		player.card_drop_location = player.Location.NONE
	

func _on_card_dropped():
	player.is_card_held = false
	player.set_trash_icon_active(false)
	player.set_use_icon_active(false)
	if GlobalVariables.debugging:
		player.show_cards()


func _on_card_picked_up():
	player.is_card_held = true
	player.set_trash_icon_active(true)
	if player.is_action_card:
		player.set_use_icon_active(true)


func highlight_cards():
	player.card_1.self_modulate = NORMAL_COLOR
	player.card_2.self_modulate = NORMAL_COLOR
	player.card_3.self_modulate = NORMAL_COLOR
	player.card_4.self_modulate = NORMAL_COLOR
	player.card_5.self_modulate = NORMAL_COLOR
