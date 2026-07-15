extends Area2D

# Assign which item resource this collectible represents in the inspector
@export var item_res: ItemData
@export var quantity: int = 1

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Update the sprite texture dynamically if a resource is present
	if item_res and item_res.icon:
		sprite.texture = item_res.icon

	# This connects the body_entered signal via code 
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
		

func _on_body_entered(body: Node2D) -> void:
	# Verify that the overlapping body is indeed the Player and has inventory
	if "inventory" in body and body.inventory != null:
		var success = body.inventory.add_item(item_res, quantity)
		if success:
			print("Successfully added to inventory: ", item_res.item_name, " x", quantity)
			queue_free() # remove the collectible from the scene
