extends CPUParticles2D

func _ready() -> void:
	emitting = true # Start emitting particles immediately
	
	# Wait until the lifetime ends, then delete the node 
	await get_tree().create_timer(lifetime + 0.1).timeout
	queue_free()
