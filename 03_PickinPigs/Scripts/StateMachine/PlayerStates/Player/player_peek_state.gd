class_name PlayerPeekState
extends State

# let's the player click on one of their cards
# shows them the card they chose in the middle of the screen
# waits for a confirmation click and then exits the state

@onready var player = $"../.." as Player
@onready var card_1 = $"../../Card1" as Sprite2D
@onready var card_2 = $"../../Card2" as Sprite2D
@onready var card_3 = $"../../Card3" as Sprite2D
@onready var card_4 = $"../../Card4" as Sprite2D
@onready var card_5 = $"../../Card5" as Sprite2D

@onready var peek_label = $"../../PromptsOverlay/PeekLabel"


const INITIAL_Y_POS = 512


var is_select_active : bool = false
var last_card_pressed : int = -1

func _ready():
	set_process(false)
	
	
func _enter_state():
	last_card_pressed = -1
	is_select_active = true
	peek_label.visible = true
	set_process(true)
	

func _exit_state():
	is_select_active = false
	player.reset_card_positions()
	peek_label.visible = false
	set_process(false)
	

func _process(_delta):
	pass


func _on_card_1_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 1:
		await player.show_card(last_card_pressed)
		player.slow_end_turn()	
	else:
		last_card_pressed = 1
		push_card_up(last_card_pressed)
		

func _on_card_2_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 2:
		await player.show_card(last_card_pressed)		
		player.slow_end_turn()
	else:
		last_card_pressed = 2
		push_card_up(last_card_pressed)


func _on_card_3_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 3:
		await player.show_card(last_card_pressed)		
		player.slow_end_turn()		
	else:
		last_card_pressed = 3
		push_card_up(last_card_pressed)


func _on_card_4_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 4:
		await player.show_card(last_card_pressed)
		player.slow_end_turn()	
	else:
		last_card_pressed = 4
		push_card_up(last_card_pressed)
	

func _on_card_5_select_button_pressed():
	if not is_select_active: return
	if last_card_pressed == 5:
		await player.show_card(last_card_pressed)
		player.slow_end_turn()	
	else:
		last_card_pressed = 5
		push_card_up(last_card_pressed)


func push_card_up(card_num : int):
	player.reset_card_positions()
	
	if card_num == 1:
		card_1.position.y -= 20
	elif card_num == 2:
		card_2.position.y -= 20
	elif card_num == 3:
		card_3.position.y -= 20
	elif card_num == 4:
		card_4.position.y -= 20
	elif card_num == 5:
		card_5.position.y -= 20
