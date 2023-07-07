class_name InventoryCell
extends Button

@export var item: Item = null: set = _set_item

@onready var _item_icon: TextureRect = $"ItemIcon"

func _ready() -> void:
	_set_item(item)


func _set_item(value: Item) -> void:
	item = value
	if is_inside_tree():
		_item_icon.texture = value.icon if value != null else null


func _on_pressed() -> void:
	print(1)
