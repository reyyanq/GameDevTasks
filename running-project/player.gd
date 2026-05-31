extends CharacterBody2D

@export var speed: float = 150.0  # character movement speed

func _physics_process(_delta: float) -> void:
	# get the move direction vector from the input map
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# if a movement key is pressed set the velocity else slow down and stop 
	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	move_and_slide()
