class_name Deck
extends Node2D

# Will keep a map with all the cards left
# will randomly return a card that's left in the deck

@export var clickable : bool = true


signal deck_empty
signal card_pulled(card : GlobalVariables.Cards)


var cards_dict = {}


func _init():
	initialize_cards_dict()
	

func initialize_cards_dict():
	# Five cards of each, ZERO through NINE
	for i in range(10):
		cards_dict[i] = 5
	
	# Nine cards of NINE
	cards_dict[GlobalVariables.Cards.TEN] = 12
	
	# Four cards of each action card
	cards_dict[GlobalVariables.Cards.DRAW_TWO] = 4
	cards_dict[GlobalVariables.Cards.SWAP] = 4
	cards_dict[GlobalVariables.Cards.PEEK] = 4
	
	
func get_card():
	var available_cards = []
	for key in cards_dict.keys():
		if cards_dict[key] != 0:
			available_cards.append(key)
			
	var card = available_cards.pick_random()
	cards_dict[card] -= 1
	
	return card
	

func get_deck_size():
	var size = 0
	for card in cards_dict.values():
		size += card
	
	return size


func _on_deck_button_pressed():
	if clickable:
		var card = get_card()
		card_pulled.emit(card)
