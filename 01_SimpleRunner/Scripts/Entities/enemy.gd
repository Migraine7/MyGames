class_name Enemy
extends CharacterBody2D


const BASE_SPEED = -84.0


@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready():
	animated_sprite_2d.play("idle")


func _physics_process(delta):
	velocity.x = BASE_SPEED * GameData.game_speed_multiplier
	move_and_slide()
