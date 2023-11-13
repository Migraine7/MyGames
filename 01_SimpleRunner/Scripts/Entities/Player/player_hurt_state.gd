class_name PlayerHurtState
extends State


@export var actor: Player
@export var animator: AnimatedSprite2D
@export var fall_timer = 1.5


@onready var collision_shape_2d = $"../../CollisionShape2D"
@onready var sound_manager = $"../../SoundManager"


var is_dead = false


func _ready():
	set_physics_process(false)


func _enter_state() -> void:
	set_physics_process(true)
	animator.play("hurt")
	sound_manager.play_hurt_sound()


func _exit_state() -> void:
	set_physics_process(false)


func _physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	if not collision_shape_2d.disabled:
		collision_shape_2d.disabled = true
		actor.velocity.y = actor.jump_velocity
	
	actor.move_and_slide()

	if not is_dead:
		announce_player_died()


func announce_player_died():
	is_dead = true
	Events.game_over.emit()
