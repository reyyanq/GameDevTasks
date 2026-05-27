extends Node

@export var mob_scene: PackedScene

var score
var high_score = 0 # var to store the high score

func _ready():
	pass

func game_over(body = null):
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play() # game over sound

	# check for a new high score
	if score > high_score:
		high_score = score
	
	$HUD.show_game_over(high_score)

func new_game():
	score = 0

	# reset enemy spawn rate at the start
	$MobTimer.wait_time = 0.5

	$Player/CollisionShape2D.set_deferred("disabled", false)
	$Player.start($Player.screen_size / 2)
	$StartTimer.start()
	$Music.play() # start background music
	
	$HUD.update_score(score) # Reset the HUD score display
	$HUD.show_message("Get Ready")
	
	get_tree().call_group("mobs", "queue_free") # Remove enemies left over from the previous game

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

	# increase difficulty over time by spawning enemies more frequently
	if $MobTimer.wait_time > 0.25:
		$MobTimer.wait_time -= 0.01

func _on_mob_timer_timeout():
	# create a new Mob
	var mob = mob_scene.instantiate()

	# choose a random position 
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the enemy direction to the path
	mob.position = mob_spawn_location.position
	var direction = mob_spawn_location.rotation + PI / 2

	# add some randomness 
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Give the enemy a random speed
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob) # Add the enemy to the main scene
