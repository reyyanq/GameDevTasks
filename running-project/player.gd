extends CharacterBody2D

# MOVEMENT VARIABLES
@export var MAX_SPEED: float = 150.0      
@export var ACCELERATION: float = 800.0    
@export var FRICTION: float = 600.0      

# IMPULSE VARIABLES
@export var DASH_SPEED: float = 500.0 
var last_direction: Vector2 = Vector2.DOWN     

func _physics_process(delta: float) -> void:
	# get the move direction vector from the input map
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# DIRECTION CHECK: Only update if the input is strong enough (ignoring deadzones/release noise)
	if direction.length() > 0.1:
		last_direction = direction.normalized() # ensures the dash length is consistent
		
	if direction != Vector2.ZERO:
		# accelerate towards the target velocity
		var target_velocity = direction * MAX_SPEED
		velocity = velocity.move_toward(target_velocity, ACCELERATION * delta)
	else:
		# decelerate to zero using friction when keys are released
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	# DASH
	if Input.is_action_just_pressed("dash"):
		# If pressing a key, dash in that direction
		# If standing still, dash in the last saved direction
		var dash_dir = direction.normalized() if direction.length() > 0.1 else last_direction
		velocity = dash_dir * DASH_SPEED

	move_and_slide()
	
	# PUSHABLE OBJECTS LOGIC
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		
		# If collided with a RigidBody2D (pushable box)
		if collider is RigidBody2D:
			# collision.get_normal() points towards the player, so negative points towards the box
			var push_direction := -collision.get_normal()
			
			var push_force := 50.0
			collider.apply_central_impulse(push_direction * push_force)
