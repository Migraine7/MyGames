extends Node

# Participant turn-related signals
signal player_turn_start
signal player_turn_end
signal player_chose_start_cards(player_index: int, card_1: int, card_2: int)

# Bot move-related signals
signal bot_pull_card
signal bot_peek_use(card_index: int)
signal bot_draw_two_use
signal bot_seen_card(player_index: int, max_card_value: GlobalVariables.Cards, card_index: int)
signal bot_rang_bell

# Gameflow related signals
signal card_dropped
signal card_picked_up
signal trash_card
signal use_card
signal swapped_card(card_index : int)
signal chose_card(player_index: int, card_index: int)
signal card_moved(player_index: int)
signal play_animation(player_index: int, name: String)

# Debugging
signal show_cards
