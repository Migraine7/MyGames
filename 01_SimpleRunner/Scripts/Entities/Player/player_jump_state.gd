class_name PlayerJumpState
extends State


@onready var sound_manager = $"../../SoundManager"


@export var actor: Player
@export var animator: AnimatedSprite2D


signal player_landed


func _ready():
	set_physics_process(false)


func _enter_state() -> void:
	set_physics_process(true)
	sound_manager.play_jump_sound()


func _exit_state() -> void:
	set_physics_process(false)


func _physics_process(delta):
	if Input.is_action_pressed("ui_accept") and actor.is_on_floor():
		actor.velocity.y = actor.jump_velocity
	elif Input.is_action_just_released("ui_accept") and actor.velocity.y < actor.jump_velocity / 1.6:
		actor.velocity.y = actor.jump_velocity / 1.6
	elif not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta
	
	actor.move_and_slide()
	animate(actor.velocity.y)
	
	if actor.is_on_floor():
		player_landed.emit()


func animate(velocity):
	if velocity < 0:
		animator.play("jump_up")
	else:
		animator.play("jump_down")
