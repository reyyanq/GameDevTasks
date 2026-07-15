class_name ItemData
extends Resource

@export var item_name: String = ""
@export var icon: Texture2D
@export_enum("Weapon", "Potion", "Collectible", "Utility") var item_type: String = "Collectible"
@export var max_stack_size: int = 99
