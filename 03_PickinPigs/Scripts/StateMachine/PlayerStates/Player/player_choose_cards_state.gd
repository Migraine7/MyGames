class_name PlayerChooseCardsState
extends State


@onready var player = $"../.." as Player
@onready var card_1 = $"../../Card1" as Sprite2D
@onready var card_2 = $"../../Card2" as Sprite2D
@onready var card_3 = $"../../Card3" as Sprite2D
@onready var card_4 = $"../../Card4" as Sprite2D
@onready var card_5 = $"../../Card5" as Sprite2D

@onready var pick_two_label = $"../../PromptsOverlay/PickTwoLabel"


const INITIAL_Y_POS = 512


var last_card_pressed : int = -1
var chosen_counter : int = 0
var enabled_array : Array[bool] = [true, true, true, true, true]


func _ready():
	set_process(false)
	
	
func _enter_state():
	last_card_pressed = -1
	pick_two_label.visible = true
	set_process(true)
	

func _exit_state():
	set_process(false)
	player.reset_card_positions()
	pick_two_label.visible = false
	
	

func _process(_delta):
	if chosen_counter == 2:
		var chosen_indices = []
		for i in range(5):
			if enabled_array[i] == false:
				chosen_indices.append(i)
		
		Events.player_chose_start_cards.emit(player.player_id, chosen_indices[0], chosen_indices[1])
		set_process(false)


func _on_card_1_select_button_pressed():
	if chosen_counter == 2 or enabled_array[0] == false: return
	if last_card_pressed == 1:
		chosen_counter += 1
		enabled_array[0] = false
		player.move_card_out(last_card_pressed, false)		
	else:
		last_card_pressed = 1
		

func _on_card_2_select_button_pressed():
	if chosen_counter == 2 or enabled_array[1] == false: return	
	if last_card_pressed == 2:
		chosen_counter += 1
		enabled_array[1] = false
		player.move_card_out(last_card_pressed, false)				
	else:
		last_card_pressed = 2


func _on_card_3_select_button_pressed():
	if chosen_counter == 2 or enabled_array[2] == false: return	
	if last_card_pressed == 3:
		chosen_counter += 1
		enabled_array[2] = false		
		player.move_card_out(last_card_pressed, false)
	else:
		last_card_pressed = 3


func _on_card_4_select_button_pressed():
	if chosen_counter == 2 or enabled_array[3] == false: return	
	if last_card_pressed == 4:
		chosen_counter += 1
		enabled_array[3] = false		
		player.move_card_out(last_card_pressed, false)
	else:
		last_card_pressed = 4
	

func _on_card_5_select_button_pressed():
	if chosen_counter == 2 or enabled_array[4] == false: return	
	if last_card_pressed == 5:
		chosen_counter += 1
		enabled_array[4] = false		
		player.move_card_out(last_card_pressed, false)	
	else:
		last_card_pressed = 5
