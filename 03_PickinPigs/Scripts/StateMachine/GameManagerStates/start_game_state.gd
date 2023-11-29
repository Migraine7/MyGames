class_name StartGameState
extends State


@onready var game_manager = $"../.." as GameManager


var chosen_cards : Array


func _ready():
	Events.player_chose_start_cards.connect(_on_player_chose_start_cards)
	
	chosen_cards = [[], [], [], []]


func _enter_state():
	set_process(true)


func _process(_delta):
	if Input.is_anything_pressed():
		game_manager.deal_cards()
		game_manager.main_animation_player.play("press_to_start_fade_out")
		set_process(false)


func _exit_state():
	for participant in game_manager.participants:
		participant.animation_player.play("RESET")
	set_process(false)


func _on_player_chose_start_cards(player_index: int, card_1: int, card_2: int):
	chosen_cards[player_index] = [card_1, card_2]
	
	if are_all_finished():
		await get_tree().create_timer(2.0).timeout
		var player = game_manager.participants[0] as Player
		
		# Flip first player card
		player.animation_player.play("flip_chosen_card_" + str(chosen_cards[0][0] + 1) + "_beginning")
		await player.animation_player.animation_finished
		player.update_card_sprite(chosen_cards[0][0] + 1, false)
		player.animation_player.play("flip_chosen_card_" + str(chosen_cards[0][0] + 1) + "_end")
		await player.animation_player.animation_finished
		
		# Flip second player card
		player.animation_player.play("flip_chosen_card_" + str(chosen_cards[0][1] + 1) + "_beginning")
		await player.animation_player.animation_finished
		player.update_card_sprite(chosen_cards[0][1] + 1, false)
		player.animation_player.play("flip_chosen_card_" + str(chosen_cards[0][1] + 1) + "_end")
		await player.animation_player.animation_finished
		
		# Flip bot cards one by one
		for i in range(1, 4):
			var bot = game_manager.participants[i] as Bot
			
			bot.animation_player.play("chose_card_" + str(chosen_cards[i][0] + 1))
			await bot.animation_player.animation_finished			
			bot.animation_player.play("chose_card_" + str(chosen_cards[i][1] + 1))
			await bot.animation_player.animation_finished

			bot.cards_seen[bot.player_id][chosen_cards[i][0]] = bot.cards[chosen_cards[i][0]]
			bot.cards_seen[bot.player_id][chosen_cards[i][1]] = bot.cards[chosen_cards[i][1]]

		# Hide player's cards
		await get_tree().create_timer(2.0).timeout		
		player.update_card_sprite(chosen_cards[0][0] + 1, true)
		player.update_card_sprite(chosen_cards[0][1] + 1, true)

		game_manager._on_player_turn_end()
		

func are_all_finished() -> bool:
	for arr in chosen_cards:
		if arr.size() == 0:
			return false
	return true
