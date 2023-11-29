extends Node2D


@onready var player_label = $CanvasLayer/CenterContainer/VBoxContainer/PlayerLabel


var game_scene : PackedScene


func _ready():
	# Update the winner text
	if GlobalVariables.winners.size() != 1:
		player_label.text = "IT'S A TIE !"
	else:
		player_label.text = "PLAYER " + str(GlobalVariables.winners.front() + 1) + " WON !"
				
	game_scene = load("res://Scenes/playing_screen.tscn")
	

func _on_play_again_button_pressed():
	# Change scene to the playing screen
	get_tree().change_scene_to_packed(game_scene)


func _on_quit_button_pressed():
	get_tree().quit()
