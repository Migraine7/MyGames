class_name BotPlayerPeekState
extends State

@onready var bot = $"../.." as Bot


func _ready():
	set_process(false)
	
	
func _enter_state():
	peek_card()
	

func _exit_state():
	pass


func peek_card():
	# Choose a card to peek at, after using the 'Peek' action card
	var unknown_indices = []
	var i = 0
	for card in bot.cards_seen[bot.player_id]:
		if card == GlobalVariables.Cards.NONE:
			unknown_indices.append(i)
		i += 1
	
	var peek_index = unknown_indices.pick_random() if unknown_indices.size() > 0 else range(5).pick_random()
	Events.bot_peek_use.emit(peek_index)
