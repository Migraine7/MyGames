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


func _ready():
	set_process(false)
