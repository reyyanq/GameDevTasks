extends PanelContainer

var slot_index: int = -1 # tracks the position of this slot in the inventory array

func update_slot(item: ItemData, quantity: int, index: int = -1) -> void:
	if index != -1:
		slot_index = index
		
	# to prevent @onready timing crashes
	var icon_rect = get_node_or_null("Icon")
	var quantity_label = get_node_or_null("QuantityLabel")
	
	# exit if child nodes are not fully instantiated yet
	if icon_rect == null or quantity_label == null:
		return

	# Handle empty slot representation
	if item == null or quantity <= 0:
		icon_rect.texture = null
		quantity_label.text = ""
	else:
		# Apply item texture (filtering left to editor settings)
		icon_rect.texture = item.icon
		
		# Display quantity only if stackable and multiple items exist
		if item.max_stack_size > 1 and quantity > 1:
			quantity_label.text = str(quantity)
		else:
			quantity_label.text = ""


# DRAG AND DROP
func _get_drag_data(_at_position: Vector2) -> Variant:
	var inventory_ui = _find_parent_inventory_ui()
	if not inventory_ui or not inventory_ui.inventory:
		return null
		
	var slot_data = inventory_ui.inventory.slots[slot_index]
	if slot_data["item"] == null:
		return null
		
	# Create drag preview texture dynamically
	var preview_texture = TextureRect.new()
	preview_texture.texture = slot_data["item"].icon
	preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview_texture.custom_minimum_size = Vector2(32, 32)
	
	# Center the preview icon directly under the mouse cursor
	var preview = Control.new()
	preview.add_child(preview_texture)
	preview_texture.position = -Vector2(16, 16)
	set_drag_preview(preview)
	
	# Package the source inventory and index
	return {
		"inventory": inventory_ui.inventory,
		"index": slot_index
	}

# Validates if the dropped item package matches the expected format
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("inventory") and data.has("index")

# Executes the slot swap operation and updates the inventory state
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var source_inv = data["inventory"]
	var source_index = data["index"]
	
	var inventory_ui = _find_parent_inventory_ui()
	if not inventory_ui or not inventory_ui.inventory:
		return
		
	var target_inv = inventory_ui.inventory
	var target_index = slot_index
	
	# Perform swap if dragging within the same inventory resource
	if source_inv == target_inv:
		var temp = target_inv.slots[target_index].duplicate()
		target_inv.slots[target_index] = source_inv.slots[source_index]
		source_inv.slots[source_index] = temp
		
		# Notify system to redraw the UI grid
		target_inv.inventory_updated.emit()

# Recursively searches parent hierarchy to find the parent InventoryUI node
func _find_parent_inventory_ui() -> Control:
	var current = get_parent()
	while current != null:
		if current.name == "InventoryUI" or current.has_method("populate_grid"):
			return current
		current = current.get_parent()
	return null
