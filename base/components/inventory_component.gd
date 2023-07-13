class_name InventoryComponent
extends Node

signal item_added(inventory, item)
signal item_dropped(inventory, item)
signal item_used(inventory, item)
signal item_removed(inventory, item)
signal changed(inventory)

@export var max_items = 1: set = _set_max_items
@export var inventory: Inventory = null: set = _set_inventory

var emit_changed = true: set = set_emit_changed
var items: Array[Item]: get = _get_items
var _is_dirty = false

func total_slots() -> int:
	return max(max_items, items.size())


func is_empty() -> bool:
	return items.size() == 0


func has_space() -> bool:
	return items.size() < max_items


func add_item(item: Item) -> void:
	_is_dirty = true
	items.push_back(item)
	item_added.emit(self, item)
	if not emit_changed:
		return
	changed.emit(self)


func add_items(arr: Array[Item]) -> void:
	_is_dirty = true
	items.append_array(arr)
	if not emit_changed:
		return
	changed.emit(self)


func drop_item(index: int) -> void:
	if index < 0 or index >= items.size():
		return

	_is_dirty = true
	var item = items[index]
	items.remove_at(index)
	item_dropped.emit(self, item)
	if not emit_changed:
		return
	changed.emit(self)


func use_item(index: int) -> void:
	if index < 0 or index >= items.size():
		return

	_is_dirty = true
	var item = items[index]
	if not item is Consumable:
		return
	items.remove_at(index)
	item_used.emit(self, item)
	if not emit_changed:
		return
	changed.emit(self)


func remove_item(index: int) -> Item:
	if index < 0 or index >= items.size():
		return

	_is_dirty = true
	var item = items[index]
	items.remove_at(index)
	item_removed.emit(self, item)
	if not emit_changed:
		return
	changed.emit(self)
	return item


func clear() -> void:
	items.clear()
	_is_dirty = true
	if not emit_changed:
		return
	changed.emit(self)


func set_emit_changed(value: bool) -> void:
	emit_changed = value
	if _is_dirty:
		_is_dirty = false
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
