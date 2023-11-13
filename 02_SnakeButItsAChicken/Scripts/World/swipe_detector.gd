class_name SwipeDetector
extends Node


const SWIPE_MIN_LENGTH = 30


var start_touch_position : Vector2

			
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			start_touch_position = event.position
		elif event.position.distance_to(start_touch_position) >= SWIPE_MIN_LENGTH:		
			var swipe_vector = event.position - start_touch_position
			var input_event = InputEventAction.new()
			input_event.pressed = true
			if abs(swipe_vector.x) > abs(swipe_vector.y):
				if swipe_vector.x > 0:
					# Right swipe
					input_event.action = "move_right"
				else:
					# Left swipe
					input_event.action = "move_left"
			else:
				if swipe_vector.y > 0:
					# Down swipe
					input_event.action = "move_down"
				else:
					# Up swipe
					input_event.action = "move_up"

			Input.parse_input_event(input_event)
			
			# Release the action
			var release_event = InputEventAction.new()
			release_event.action = input_event.action
			release_event.pressed = false
			Input.parse_input_event(release_event)

			
			
