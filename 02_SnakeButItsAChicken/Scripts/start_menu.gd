extends Node2D


@onready var play_button = $CanvasLayer/CenterContainer/VBoxContainer/PlayButton
@onready var quit_button = $CanvasLayer/CenterContainer/VBoxContainer/QuitButton


const WORLD_PATH = "res://Scenes/world.tscn"


func _ready():
	get_tree().paused = true


func _on_play_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(WORLD_PATH)
	

func _on_quit_button_pressed():
	get_tree().quit()
