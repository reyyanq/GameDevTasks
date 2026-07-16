extends CharacterBody2D

@export var speed: float = 80.0            # patrol speed for enemy
@export var chase_speed: float = 110.0     # speed while chasing the player
@export var chase_threshold: float = 200.0 # distance at which the enemy notices the player 

# COMBAT VARIABLES
@export var hp: int = 2
var is_recoiling: bool = false             # Tracks if the enemy is currently taking knockback

# patrol points 
var patrol_points: Array[Vector2] = []
var current_point_index: int = 0
var player: CharacterBody2D = null

# navigation agent node added 
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

# Particle effects preloaded
const HIT_EFFECT = preload("res://scenes/hit_effect.tscn")
const DEATH_EFFECT = preload("res://scenes/death_effect.tscn")

func _ready() -> void:
	patrol_points.append(global_position) # the current position as the first point
	
	# create a random second patrol point nearby
	var random_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	var random_distance = randf_range(150.0, 250.0)
	patrol_points.append(global_position + (random_direction * random_distance))
	
	# find the player in the main scene 
	player = get_tree().current_scene.get_node_or_null("Player")
	
	# precision for navigation path and target
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	
	# For spawned enemies cannot cross water
	set_collision_mask_value(3, true)
	
func _physics_process(_delta: float) -> void:
	if player == null:
		return

	# Only apply normal movement AI if the enemy is NOT taking knockback
	if not is_recoiling:
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player < chase_threshold:
			chase_player_with_navigation()
		else:
			patrol()
	else:
		# Smoothly decelerate the knockback velocity to zero over time
		velocity = velocity.move_toward(Vector2.ZERO, 800.0 * _delta)

	move_and_slide()
	
	# CONTACT DAMAGE LOGIC 
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		
		if collider.has_method("take_damage"):
			collider.take_damage(1) 

func patrol() -> void:
	var target_point = patrol_points[current_point_index]
	var direction = global_position.direction_to(target_point)
	velocity = direction * speed

	if global_position.distance_to(target_point) < 5.0:
		current_point_index = (current_point_index + 1) % patrol_points.size()

func chase_player() -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * chase_speed
	
func chase_player_with_navigation() -> void:
	nav_agent.target_position = player.global_position
	var next_path_position = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_position)
	velocity = direction * chase_speed

# Processes damage, triggers appropriate particles, and handles knockback 
func take_damage(amount: int) -> void:
	hp -= amount
	print("Enemy hit! Remaining HP: ", hp)
	
	# SPAWN HIT PARTICLES
	# Spawn red hit spark particles upon taking damage
	var hit_particle = HIT_EFFECT.instantiate()
	hit_particle.global_position = global_position
	get_tree().current_scene.add_child(hit_particle)
	
	# Handle death sequence if health drops to or below zero
	if hp <= 0:
		die()
		return
	
	# KNOCKBACK EFFECT 
	var current_player = get_tree().current_scene.get_node_or_null("Player")
	if current_player:
		var knockback_direction = global_position.direction_to(current_player.global_position).normalized()
		var knockback_force = 200.0 
		
		velocity = -knockback_direction * knockback_force
		is_recoiling = true
		modulate.a = 0.4
		
		# Stop recoil state and reset opacity after 0.2 seconds
		await get_tree().create_timer(0.2).timeout
		is_recoiling = false
		modulate.a = 1.0

func die() -> void:
	# SPAWN DEATH PARTICLES 
	# Spawn grey smoke particles upon death
	var death_particle = DEATH_EFFECT.instantiate()
	death_particle.global_position = global_position
	get_tree().current_scene.add_child(death_particle)
	
	queue_free()
