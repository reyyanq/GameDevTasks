extends CharacterBody2D

@export var speed: float = 80.0            # patrol speed for enemy
@export var chase_speed: float = 110.0     # speed while chasing the player
@export var chase_threshold: float = 200.0 # distance at which the enemy notices the player 

# patrol points 
var patrol_points: Array[Vector2] = []
var current_point_index: int = 0
var player: CharacterBody2D = null

# navigation agent node added 
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

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

func _physics_process(_delta: float) -> void:
	if player == null:
		return

	# distance between the enemy and the player
	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player < chase_threshold:
		# chase mode: if the player is close -> move toward them
		chase_player_with_navigation()
	else:
		# patrol mode: if the player is far away -> continue patrolling
		patrol()

	move_and_slide()

func patrol() -> void:
	var target_point = patrol_points[current_point_index]
	var direction = global_position.direction_to(target_point)
	velocity = direction * speed

	# if the enemy is very close to the target point, switch to the next patrol point
	if global_position.distance_to(target_point) < 5.0:
		current_point_index = (current_point_index + 1) % patrol_points.size()

func chase_player() -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * chase_speed
	
func chase_player_with_navigation() -> void:
	# set the player's position as the navigation target
	nav_agent.target_position = player.global_position

	# get the next safe point on the path
	var next_path_position = nav_agent.get_next_path_position()

	# move toward the safe path point
	var direction = global_position.direction_to(next_path_position)
	velocity = direction * chase_speed
