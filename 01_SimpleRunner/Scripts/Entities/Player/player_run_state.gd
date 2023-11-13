extends State
class_name PlayerRunState


@export var actor: Player
@export var animator: AnimatedSprite2D


signal player_jumped


func _ready():
	set_physics_process(false)


func _enter_state() -> void:
	set_physics_process(true)
	animator.play("run")


func _exit_state() -> void:
	set_physics_process(false)


func _physics_process(delta):
	actor.move_and_slide()
	if Input.is_action_just_pressed("ui_accept") and actor.is_on_floor():
		player_jumped.emit()
