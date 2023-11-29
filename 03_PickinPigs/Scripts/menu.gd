extends Node2D


@onready var animation_player = $AnimationPlayer

@onready var how_to_overlay = $HowToOverlay
@onready var next_button = $HowToOverlay/NextButton
@onready var previous_button = $HowToOverlay/PreviousButton
@onready var sprite_2d = $HowToOverlay/Sprite2D


const HOW_TO_PAGES = 10


var game_scene : PackedScene
var current_how_to_page = 1


func _ready():
	game_scene = preload("res://Scenes/playing_screen.tscn")
	SoundManager.animation_player.play("bg_music_fade_in")	


func _on_start_button_pressed():
	animation_player.play("fade_out")
	SoundManager.animation_player.play("bg_music_fade_out")
	await SoundManager.animation_player.animation_finished
	get_tree().change_scene_to_packed(game_scene)


func _on_how_to_button_pressed():
	sprite_2d.texture = load("res://Assets/HowTo/1.png")
	how_to_overlay.visible = true
	previous_button.disabled = true
	next_button.disabled = false


func _on_exit_button_pressed():
	get_tree().quit()


func _on_back_button_pressed():
	how_to_overlay.visible = false


func _on_previous_button_pressed():
	previous_button.release_focus()
	current_how_to_page -= 1
	sprite_2d.texture = load("res://Assets/HowTo/" + str(current_how_to_page) + ".png")
	next_button.disabled = false
	
	if current_how_to_page == 1:
		previous_button.disabled = true
		

func _on_next_button_pressed():
	next_button.release_focus()	
	current_how_to_page += 1
	sprite_2d.texture = load("res://Assets/HowTo/" + str(current_how_to_page) + ".png")
	previous_button.disabled = false
	
	if current_how_to_page == HOW_TO_PAGES:
		next_button.disabled = true
