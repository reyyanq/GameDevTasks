extends Node2D

# load the enemy scene into memory 
var enemy_scene = preload("res://enemy.tscn")

@onready var spawner_node = $Spawner
@onready var timer_node = $Spawner/Timer

func _ready() -> void:
	timer_node.timeout.connect(spawn_enemy) # when timer finishes call the spawn_enemy function

func spawn_enemy() -> void:
	# create a new instance of the enemy scene
	var new_enemy = enemy_scene.instantiate()

	# set the enemy's position
	new_enemy.global_position = spawner_node.global_position

	add_child(new_enemy)
