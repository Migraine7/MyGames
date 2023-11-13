extends StaticBody2D


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var shake_timer = $ShakeTimer


func _on_collision_detector_area_entered(area):
	Events.picked_up_egg.emit()
	queue_free()


func _on_shake_timer_timeout():
	animated_sprite_2d.play("idle")
	shake_timer.start()
