extends RigidBody2D

func _ready():
	# access the node
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	
	# choose animation (fly-swim-walk)
	# randi() % 3 returns either 0-1-2
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Remove the enemy from memory when it leaves the screen
