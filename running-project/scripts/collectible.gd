extends Area2D

# Assign which item resource this collectible represents in the inspector
@export var item_res: ItemData
@export var quantity: int = 1

# the pickup particle effect scene
const PICKUP_EFFECT = preload("res://scenes/pickup_effect.tscn")

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Update the sprite texture dynamically if a resource is present
	if item_res and item_res.icon:
		sprite.texture = item_res.icon

	# This connects the body_entered signal via code 
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
		

func _on_body_entered(body: Node2D) -> void:
	# Check if the colliding object is the player and has an inventory
	if "inventory" in body and body.inventory != null:
		var success = body.inventory.add_item(item_res, quantity)
		if success:
			# trigger the visual particle effect
			var effect = PICKUP_EFFECT.instantiate()
			effect.global_position = global_position
			get_tree().current_scene.add_child(effect)
			
			print("Successfully added to inventory: ", item_res.item_name)
			queue_free() 
