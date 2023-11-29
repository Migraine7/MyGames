class_name PlayerSwapState
extends State

# trashes the card
# allows the player to choose one of their own cards
# darkens the player's cards and highlights all the other cards
# allows the player to choose one of the opponents' cards
# swaps the two cards


@onready var player = $"../.." as Player
@onready var card_1 = $"../../Card1" as Sprite2D
@onready var card_2 = $"../../Card2" as Sprite2D
@onready var card_3 = $"../../Card3" as Sprite2D
@onready var card_4 = $"../../Card4" as Sprite2D
@onready var card_5 = $"../../Card5" as Sprite2D

@onready var swap_label = $"../../PromptsOverlay/SwapLabel"


const INITIAL_Y_POS = 512


var is_select_active : bool = false
var last_card_pressed : int = -1
var is_player_done : bool = true
var swap_chosen_counter : int = 0


func _ready():
	Events.chose_card.connect(_on_chose_card)
	set_process(false)
	
	
func _enter_state():
	is_player_done = false
	last_card_pressed = -1
	is_select_active = true
	swap_label.visible = true
	set_process(true)
	

func _exit_state():
	set_process(false)
	is_select_active = false
	player.reset_card_positions()
	swap_label.visible = false	
	

func _process(_delta):
	if is_player_done:
		await get_tree().create_timer(6.0).timeout
		set_process(false)


func _on_card_1_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 1:
		Events.chose_card.emit(player.player_id, 0)
	else:
		last_card_pressed = 1
		player.move_card_out(last_card_pressed)
		

func _on_card_2_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 2:
		Events.chose_card.emit(player.player_id, 1)
	else:
		last_card_pressed = 2
		player.move_card_out(last_card_pressed)


func _on_card_3_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 3:
		Events.chose_card.emit(player.player_id, 2)
	else:
		last_card_pressed = 3
		player.move_card_out(last_card_pressed)


func _on_card_4_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 4:
		Events.chose_card.emit(player.player_id, 3)
	else:
		last_card_pressed = 4
		player.move_card_out(last_card_pressed)
	

func _on_card_5_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 5:
		Events.chose_card.emit(player.player_id, 4)
	else:
		last_card_pressed = 5
		player.move_card_out(last_card_pressed)


func _on_chose_card(_player_index, _card_index):
	if player.is_human_player_turn:
		swap_chosen_counter += 1
		if swap_chosen_counter % 2 == 0:
			is_player_done = true
		
		is_select_active = false
		last_card_pressed = -1
