extends Node


@onready var animation_player = $AnimationPlayer
@onready var egg_pickup_sound = $EggPickupSound
@onready var speedup_sound = $SpeedupSound


func _ready():
	Events.warn_speed_up.connect(_on_warn_speed_up)
	Events.picked_up_egg.connect(_on_picked_up_egg)
	Events.game_over.connect(_on_game_over)


func _on_warn_speed_up():
	speedup_sound.play()


func _on_picked_up_egg():
	egg_pickup_sound.play()
	

func _on_game_over():
	animation_player.play("background_fade_out")
