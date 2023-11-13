extends Timer


func _ready():
	start()


func _on_timeout():
	start()
	Events.level_up.emit()
