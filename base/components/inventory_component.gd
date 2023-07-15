class_name InventoryComponent
extends Node

signal item_added(inventory, item)
signal item_dropped(inventory, item)
signal item_used(inventory, item)
signal item_removed(inventory, item)
signal changed(inventory)

@export var max_items = 1: set = _set_max_items
@export var inventory: Inventory = null: set = _set_inventory

var items: Array[Item]: get = _get_items

func total_slots() -> int:
	return max(max_items, items.size())


func total_slots_filtered(p: Callable) -> int:
	if max_items > items.size():
		return max_items

	var result = 0
	for i in items:
		if p.call(i):
			result += 1

	return max(max_items, result)


func is_empty() -> bool:
	return items.size() == 0


func has_space() -> bool:
	return items.size() < max_items


func add_item(item: Item) -> void:
	items.push_back(item)
	item_added.emit(self, item)
	changed.emit(self)


func add_items(arr: Array[Item]) -> void:
	if arr.size() == 0:
		return
	items.append_array(arr)
	changed.emit(self)


func drop_item(index: int) -> void:
	if index < 0 or index >= items.size():
		return

	var item = items[index]
	items.remove_at(index)
	item_dropped.emit(self, item)
	changed.emit(self)


func use_item(index: int) -> void:
	if index < 0 or index >= items.size():
		return

	var item = items[index]
	if not item is Consumable:
		return
	items.remove_at(index)
	item_used.emit(self, item)
	changed.emit(self)


func remove_item(index: int) -> Item:
	if index < 0 or index >= items.size():
		return

	var item = items[index]
	items.remove_at(index)
	item_removed.emit(self, item)
	changed.emit(self)
	return item


func clear() -> void:
	items.clear()
	changed.emit(self)


func _get_items() -> Array[Item]:
	if inventory == null:
		return []
	return inventory.items


func _set_max_items(value: int) -> void:
	max_items = value
	changed.emit(self)


func _set_inventory(i: Inventory) -> void:
	inventory = i
	changed.emit(self)
