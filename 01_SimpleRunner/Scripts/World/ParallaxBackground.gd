extends ParallaxBackground


const PARALLAX_LAYERS_GROUP = "ParallaxLayers"


@export var background_speed = 8


func _process(delta):
	move_background(delta)


func move_background(delta):
	var parallax_layers_array = get_tree().get_nodes_in_group(PARALLAX_LAYERS_GROUP)
	var layer_speed_multiplier = 1
	for parallax_layer in parallax_layers_array:
		parallax_layer.motion_offset.x -= layer_speed_multiplier * background_speed * GameData.game_speed_multiplier * delta
		layer_speed_multiplier *= 1.6
