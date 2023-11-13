class_name BotPlayerTurnState
extends State


@onready var player = $"../.."


const NORMAL_COLOR = Color(1, 1, 1, 1)


func _ready():
	set_process(false)


func _enter_state():
	set_process(true)
	highlight_cards()


func _exit_state():
	set_process(false)


func _process(_delta):
	pass


func highlight_cards():
	player.card_1.self_modulate = NORMAL_COLOR
	player.card_2.self_modulate = NORMAL_COLOR
	player.card_3.self_modulate = NORMAL_COLOR
	player.card_4.self_modulate = NORMAL_COLOR
	player.card_5.self_modulate = NORMAL_COLOR
