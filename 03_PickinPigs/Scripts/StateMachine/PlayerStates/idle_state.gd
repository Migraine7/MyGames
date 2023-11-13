class_name PlayerIdleState
extends State

# darkens the player's cards, and does not allow picking up cards.
# supposed to allow pausing and exiting the game
@onready var player = $"../.."
@onready var card_1 = $"../../Card1"
@onready var card_2 = $"../../Card2"
@onready var card_3 = $"../../Card3"
@onready var card_4 = $"../../Card4"
@onready var card_5 = $"../../Card5"


const DARK_COLOR = Color(0.4, 0.4, 0.4, 1)


func _ready():
	set_process(false)


func _process(_delta):
	pass


func _enter_state():
	set_process(true)
	darken_cards()


func _exit_state():
	set_process(false)


func darken_cards():
	card_1.self_modulate = DARK_COLOR
	card_2.self_modulate = DARK_COLOR
	card_3.self_modulate = DARK_COLOR
	card_4.self_modulate = DARK_COLOR
	card_5.self_modulate = DARK_COLOR
