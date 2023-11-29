class_name BotPlayerChooseCardsState
extends State

@onready var bot = $"../.." as Bot


func _ready():
	set_process(false)
	
	
func _enter_state():
	set_process(true)
	

func _process(_delta):
	choose_cards()
	set_process(false)	


func _exit_state():
	set_process(false)


func choose_cards():
	# Choose two cards to peek at, at the beginning of the game
	var indices = range(5)
	var card_1 = indices.pick_random()
	indices.pop_at(card_1)
	var card_2 = indices.pick_random()
	Events.player_chose_start_cards.emit(bot.player_id, card_1, card_2)
