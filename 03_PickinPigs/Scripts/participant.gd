class_name Participant
extends Node2D


@export var cards : Array[GlobalVariables.Cards]
@export var is_action_card : bool = false
@export var player_id : int


@export var states_stack : Array


@onready var card_1 = $Card1
@onready var card_2 = $Card2
@onready var card_3 = $Card3
@onready var card_4 = $Card4
@onready var card_5 = $Card5


func show_cards():
	card_1.texture = load("res://Assets/cards/" + GlobalVariables.Cards.keys()[cards[0]].to_lower() + ".png")
	card_2.texture = load("res://Assets/cards/" + GlobalVariables.Cards.keys()[cards[1]].to_lower() + ".png")
	card_3.texture = load("res://Assets/cards/" + GlobalVariables.Cards.keys()[cards[2]].to_lower() + ".png")
	card_4.texture = load("res://Assets/cards/" + GlobalVariables.Cards.keys()[cards[3]].to_lower() + ".png")
	card_5.texture = load("res://Assets/cards/" + GlobalVariables.Cards.keys()[cards[4]].to_lower() + ".png")
