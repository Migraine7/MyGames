class_name BotPlayerTurnState
extends State


@onready var bot = $"../.." as Bot

@onready var state_machine = $".." as StateMachine
@onready var bot_player_draw_two_state = $"../BotPlayerDrawTwoState"
@onready var bot_player_peek_state = $"../BotPlayerPeekState"
@onready var bot_player_swap_state = $"../BotPlayerSwapState"

@onready var animation_player = $"../../AnimationPlayer"


var rng = RandomNumberGenerator.new()


const NORMAL_COLOR = Color(1, 1, 1, 1)


func _ready():
	set_process(false)


func _enter_state():
	set_process(true)
	if GlobalVariables.debugging:
		bot.debug_this_bot_seen_cards_icon()
	play_turn()


func _exit_state():
	set_process(false)


func _process(_delta):
	pass


func play_turn():
	await get_tree().create_timer(1.0).timeout	
	
	# Decide if it's worth to ring the bell
	if decide_ring_bell():
		Events.bot_rang_bell.emit()
		return
	
	var playable_card = bot.top_stack_card as Card if bot.top_stack_card else null
	
	# Decide on using the top stack card
	if playable_card and playable_card.pickable:
		if playable_card.card_value > GlobalVariables.Cards.TEN:
			# Card is an action card
			if decide_play_action_card():
				Events.use_card.emit()
				await get_tree().create_timer(0.7).timeout	
				SoundManager.play_use_card_sfx()				
				return
				
		
		if decide_card_worth(playable_card, true):
			play_card(playable_card)
			return
	
	# Pull a new card from the deck
	Events.bot_pull_card.emit()
	await get_tree().create_timer(1.0).timeout
	playable_card = bot.card_pulled
	
	# Decide on using the deck card
	if playable_card.card_value > GlobalVariables.Cards.TEN:
		# Card is an action card
		if decide_play_action_card():
			Events.use_card.emit()
			await get_tree().create_timer(0.7).timeout			
			SoundManager.play_use_card_sfx()							
			return			
	
	elif decide_card_worth(playable_card, false):
		play_card(playable_card)
		return
	
	# Card is not good enough to play, trash it and end turn
	Events.trash_card.emit()
	await get_tree().create_timer(0.7).timeout		
	SoundManager.play_trash_card_sfx()	
	bot.slow_end_turn()


func get_worst_card_index() -> int:
	var worst_card = GlobalVariables.Cards.ZERO
	var worst_card_index = 0
	var i = 0
	for card in bot.cards_seen[bot.player_id]:
		if card != GlobalVariables.Cards.NONE and card > worst_card:
			worst_card = card
			worst_card_index = i
		i += 1
	
	return worst_card_index


func decide_play_action_card() -> bool:
	# Always use an action card
	return true
	

func decide_card_worth(card: Card, is_from_stack: bool) -> bool:
	if card.card_value == GlobalVariables.Cards.ZERO:
		return true
	
	var bot_cards = bot.cards_seen[bot.player_id] as Array
	var worst_card = bot_cards[get_worst_card_index()]
	
	# If the bot has some unknown cards, allow it to pick cards considered good enough to gamble on.
	if bot_cards.has(GlobalVariables.Cards.NONE):
		if card.card_value < GlobalVariables.Cards.SIX:
			return true
	
	# Pick a card from the stack if it's certainly better than the bot's worst card.
	# Card should be better by at least 2 point to pick from the stack,
	if is_from_stack:
		if card.card_value < worst_card - 1 and worst_card != GlobalVariables.Cards.NONE:
			return true
	
	# Pick a card from the deck if it's better than the bot's worst card.
	else:
		if card.card_value < worst_card and worst_card != GlobalVariables.Cards.NONE:
			return true
		
	return false


func play_card(card: Card):	
	var bot_cards = bot.cards_seen[bot.player_id] as Array
	var swap_index = get_worst_card_index()
	var worst_card = bot_cards[swap_index]

	if card.card_value > worst_card or randf() < 0.5:
		# Bot choosing to swap with an unknown card it has
		var unknown_indices = []
		var i = 0
		for card_seen in bot.cards_seen[bot.player_id]:
			if card_seen == GlobalVariables.Cards.NONE:
				unknown_indices.append(i)
			i += 1
		if unknown_indices.size() != 0:
			swap_index = unknown_indices.pick_random()
	
	# Update the bot's seen card value
	bot.cards_seen[bot.player_id][swap_index] = card.card_value
	
	animation_player.play("throw_card_" + str(swap_index + 1))
	
	Events.swapped_card.emit(swap_index)
	await get_tree().create_timer(2.0).timeout
		
	animation_player.play("RESET")
		
	bot.slow_end_turn()


func decide_ring_bell():
	# Decide if it's worth ringing the bell to end the game
	var bot_cards = bot.cards_seen[bot.player_id] as Array
	var sum = 0
	
	for card in bot_cards:
		if card == GlobalVariables.Cards.NONE:
			return false
		sum += card if card <= 10 else 11
		
	if sum < 8:
		return true
	
	return false
