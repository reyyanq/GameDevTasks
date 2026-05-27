extends Node2D

func _process(delta):
	# Continuously rotate all child nodes 
	for child in get_children():
		if child is Area2D:
			child.rotation += 2.0 * delta # delta ensures the speed is the same regardless of framerate

var message = "Hello Godot"

func _ready():
	print(message)
