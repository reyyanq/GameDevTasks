class_name Inventory
extends Resource

signal inventory_updated

# { "item": ItemData, "quantity": int }
@export var slots: Array[Dictionary] = []
@export var max_slots: int = 9

func _init() -> void:
	# Initialize empty slots
	slots.resize(max_slots)
	for i in range(max_slots):
		slots[i] = { "item": null, "quantity": 0 }

# Adds an item to the inventory, respecting stack limits
func add_item(item: ItemData, amount: int = 1) -> bool:
	var remaining_amount = amount

	# try to find existing stacks of the same item that aren't full yet
	for slot in slots:
		if slot["item"] == item:
			var space_left = item.max_stack_size - slot["quantity"]
			if space_left > 0:
				var add_to_stack = min(remaining_amount, space_left)
				slot["quantity"] += add_to_stack
				remaining_amount -= add_to_stack
				
				if remaining_amount <= 0:
					inventory_updated.emit()
					return true

	# if there is still item left, find an empty slot to start a new stack
	while remaining_amount > 0:
		var empty_slot_index = _find_empty_slot()
		if empty_slot_index == -1:
			# inventory is full
			inventory_updated.emit()
			return false
			
		var add_to_new_stack = min(remaining_amount, item.max_stack_size)
		slots[empty_slot_index] = {
			"item": item,
			"quantity": add_to_new_stack
		}
		remaining_amount -= add_to_new_stack

	inventory_updated.emit()
	return true

# Removes an item from a specific slot
func remove_item_at(index: int) -> void:
	if index >= 0 and index < slots.size():
		slots[index] = { "item": null, "quantity": 0 }
		inventory_updated.emit()

func _find_empty_slot() -> int:
	for i in range(slots.size()):
		if slots[i]["item"] == null:
			return i
	return -1
