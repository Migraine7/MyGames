extends State
class_name PlayerIdleState


@export var actor: Player
@export var animator: AnimatedSprite2D


signal game_started


func _ready():
	set_physics_process(false)


func _enter_state() -> void:
	set_physics_process(true)
	animator.play("idle")


func _exit_state() -> void:
	set_physics_process(false)


func _physics_process(delta):
	if Input.is_anything_pressed():
		game_started.emit()
