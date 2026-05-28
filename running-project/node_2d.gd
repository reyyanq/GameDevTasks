extends Node2D

func _process(delta):
	# Continuously rotate all child nodes 
	for child in get_children():
		if child is Area2D:
			child.rotation += 2.0 * delta # delta ensures the speed is the same regardless of framerate

func _unhandled_input(event):
	if event.is_action_pressed("color_changed_1"):
		$Area2D_1.modulate = Color.RED
	elif event.is_action_pressed("color_changed_2"):
		$Area2D_2.modulate = Color.GREEN
	elif event.is_action_pressed("color_changed_3"):
		$Area2D_3.modulate = Color.BLUE
