extends PanelContainer

const SLOT_SCENE = preload("res://scenes/inventory_slot.tscn")

var inventory: Inventory 

func _ready() -> void:
	hide()

func set_inventory(new_inventory: Inventory) -> void:
	inventory = new_inventory
	
	# Redraw the grid whenever the inventory contents change
	inventory.inventory_updated.connect(populate_grid)
	populate_grid()

# Clears the grid and rebuilds slots
func populate_grid() -> void:
	var grid_node = get_node_or_null("MarginContainer/Grid")
	if grid_node == null:
		return
			
	# Remove all existing visual slots from the grid
	for child in grid_node.get_children():
		child.queue_free()
		
	# Instantiate and configure a new slot node for every inventory slot
	var index = 0
	for slot in inventory.slots:
		var slot_node = SLOT_SCENE.instantiate()
		grid_node.add_child(slot_node)
		
		# Pass item data-quantity-array index for drag & drop
		slot_node.update_slot(slot["item"], slot["quantity"], index)
		index += 1
