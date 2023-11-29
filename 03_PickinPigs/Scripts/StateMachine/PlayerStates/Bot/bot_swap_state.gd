class_name BotPlayerSwapState
extends State


@onready var bot = $"../.." as Bot


var rng = RandomNumberGenerator.new()


func _ready():
	set_process(false)


func _enter_state():
	pick_bot_card_to_swap()
	await get_tree().create_timer(0.5).timeout	
	pick_best_seen_card()
	await get_tree().create_timer(6.0).timeout


func pick_bot_card_to_swap():
	# Pick the worst card the bot has
	var worst_card = GlobalVariables.Cards.ZERO
	var worst_card_index = 0
	var unknown_indices = []
	
	var i = 0
	for card in bot.cards_seen[bot.player_id]:
		if card == GlobalVariables.Cards.NONE:
			unknown_indices.append(i)
		else:
			if card > worst_card:
				worst_card = card
				worst_card_index = i
		i += 1
	
	if rng.randf() < (float(worst_card) / 10.0):
		# worst card will be swapped
		pass
	elif unknown_indices.size() > 0:
		worst_card_index = unknown_indices.pick_random()
	
	Events.chose_card.emit(bot.player_id, worst_card_index)


func pick_best_seen_card():
	# Pick the best card the bot assumes other players have
	var best_card = GlobalVariables.Cards.NONE
	var best_card_player = 0
	var best_card_index = rng.randi_range(0, 4)
	
	for player_index in range(bot.cards_seen.size()):
		if player_index == bot.player_id: continue
		
		var player_cards_seen = bot.cards_seen[player_index]
		for card_index in range(player_cards_seen.size()):
			if player_cards_seen[card_index] < best_card:
				best_card = player_cards_seen[card_index]
				best_card_player = player_index
				best_card_index = card_index
	
	Events.chose_card.emit(best_card_player, best_card_index)
