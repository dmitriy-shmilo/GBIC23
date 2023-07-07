class_name InventoryComponent
extends Node

signal item_added(inventory, item)
signal item_dropped(inventory, item)
signal changed(inventory)


@export var max_items = 1: set = _set_max_items
@export var items : Array[Item] = []


func has_space() -> bool:
	return items.size() < max_items


func add_item(item: Item) -> void:
	if items.size() >= max_items:
		return

	items.push_back(item)
	item_added.emit(self, item)
	changed.emit(self)


func drop_item(index: int) -> void:
	if index < 0 or index >= items.size():
		return

	var item = items[index]
	items.remove_at(index)
	item_dropped.emit(self, item)
	changed.emit(self)


func _set_max_items(value: int) -> void:
	max_items = value
	changed.emit(self)
