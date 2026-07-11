extends CharacterBody2D

# MOVEMENT VARIABLES
@export var MAX_SPEED: float = 150.0      
@export var ACCELERATION: float = 800.0    
@export var FRICTION: float = 600.0      

# IMPULSE VARIABLES
@export var DASH_SPEED: float = 400.0 
var last_direction: Vector2 = Vector2.DOWN     

# COMBAT VARIABLES
@export var max_hp: int = 5
@onready var current_hp: int = max_hp
@onready var attack_shape: CollisionShape2D = $AttackArea/CollisionShape2D

var is_invincible: bool = false
@onready var invincibility_timer: Timer = $InvincibilityTimer

# MOBILITY VARIABLES
@export var DASH_COOLDOWN: float = 1.0
var is_dashing: bool = false
var can_dash: bool = true

func _physics_process(delta: float) -> void:
	# get the move direction vector from the input map
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# DIRECTION CHECK: Only update if the input is strong enough
	if direction.length() > 0.1:
		last_direction = direction.normalized()
		
	# MOVEMENT
	# Only allow normal movement if the player is NOT currently dashing
	if not is_dashing:
		if direction != Vector2.ZERO:
			# accelerate towards the target velocity
			var target_velocity = direction * MAX_SPEED
			velocity = velocity.move_toward(target_velocity, ACCELERATION * delta)
		else:
			# decelerate to zero using friction when keys are released
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# DASH 
	# Calls start_dash() properly and respects cooldown requirements
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		start_dash(direction)

	# ATTACK
	if Input.is_action_just_pressed("attack"): 
		attack()
		
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

func attack() -> void:
	print("Attacking!")
	attack_shape.disabled = false # Activate attack area
	
	# Auto close the attack area back after 0.2 seconds
	await get_tree().create_timer(0.2).timeout
	attack_shape.disabled = true
	
func take_damage(amount: int) -> void:
	# Prevent taking damage if the player is in the immortality period
	if is_invincible:
		return
		
	current_hp -= amount
	print("Player hit! Remaining HP: ", current_hp)
	
	# Initiate immortality as soon as the player takes damage
	is_invincible = true
	invincibility_timer.start()
	
	# Visual: temp changes the player's color to translucent
	modulate.a = 0.5
	
	# KNOCKBACK  
	# opposite direction based on the player's current velocity
	var knockback_direction = -velocity.normalized()
	
	if knockback_direction == Vector2.ZERO:
		knockback_direction = Vector2.UP # default the knockback direction to upward
		
	var knockback_force = 300.0
	velocity = knockback_direction * knockback_force
	
	if current_hp <= 0:
		die()

func die() -> void:
	print("Player died!")
	get_tree().reload_current_scene()

func start_dash(move_dir: Vector2) -> void:
	is_dashing = true
	can_dash = false
	
	# Determine dash direction
	var dash_dir = move_dir.normalized() if move_dir.length() > 0.1 else last_direction
	velocity = dash_dir * DASH_SPEED
	
	# PHASE DASH & GAP CROSSING
	# Turn off collision detection for Layer 2 (Enemies) and Layer 3 (Gaps) during dash
	set_collision_mask_value(2, false)
	set_collision_mask_value(3, false)
	
	# DASH INVINCIBILITY 
	is_invincible = true
	modulate.a = 0.5 # Translucent effect during dash
	
	# Dash lasts for 0.2 seconds
	await get_tree().create_timer(0.3).timeout
	end_dash()
	
	# Cooldown period
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	can_dash = true
	print("Dash is ready again!")

func end_dash() -> void:
	is_dashing = false
	velocity = Vector2.ZERO
	
	# Restore normal collision masks after dash ends
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
	
	# Restore invincibility state
	is_invincible = false
	modulate.a = 1.0


func _on_attack_area_body_entered(body: Node2D) -> void:
	# If the object entering the area is an enemy and there is a "take_damage" function
	if body.has_method("take_damage") and body != self:
		body.take_damage(1)

func _on_invincibility_timer_timeout() -> void:
	is_invincible = false
	modulate.a = 1.0 # player's color to its original state
