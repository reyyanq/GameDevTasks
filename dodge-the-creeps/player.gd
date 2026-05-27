extends Area2D

# Player movement speed
@export var speed = 400

var screen_size

func _ready():
	# Auto get the screen size when the game starts
	screen_size = get_viewport_rect().size
	position = screen_size / 2
	show()

func _process(delta):
	# player movement direction vector
	var velocity = Vector2.ZERO

	# check input
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	# Assign the animation node to a variable
	var animated_sprite = $AnimatedSprite2D

	# if movement key is pressed, move the character and play animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		animated_sprite.play() 
	else:
		animated_sprite.stop() # stop animation

	# Update player position
	position += velocity * delta
	
	# prevent the character from leaving the screen
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# select the correct animation based on direction and flip the sprite when necessary
	if velocity.x != 0:
		animated_sprite.animation = "walk"
		
		# face right normally, flip horizontally when moving left
		animated_sprite.flip_h = velocity.x < 0

	elif velocity.y != 0:
		animated_sprite.animation = "up"

		# face upward normally, flip vertically when moving down
		animated_sprite.flip_v = velocity.y > 0
		
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
