class_name Inventory
extends Resource


@export var items : Array[Item] = []: set = set_items

var _is_updating = false
var _was_changed = false

func begin_updates() -> void:
	_is_updating = true


func end_updates() -> void:
	_is_updating = false
	if _was_changed:
		_was_changed = false
		emit_changed()


func set_items(value: Array[Item]) -> void:
	items = value
	if _is_updating:
		_was_changed = true
	else:
		emit_changed()


func clear() -> void:
	items.clear()
	if _is_updating:
		_was_changed = true
	else:
		emit_changed()


func add_item(item: Item) -> void:
	items.push_back(item)
	if _is_updating:
		_was_changed = true
	else:
		emit_changed()
