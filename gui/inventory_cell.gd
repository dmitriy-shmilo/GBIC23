class_name InventoryCell
extends Button

const EMPTY_ITEM = preload("res://items/empty.tres")

@export var item: Item = EMPTY_ITEM: set = _set_item
## Item index within the inventory
@export var index: int = -1

@onready var _item_icon: TextureRect = $"ItemIcon"

func _ready() -> void:
	_set_item(item)
	focus_entered.connect(_on_focus_entered)
	pressed.connect(_on_pressed)


func is_empty() -> bool:
	return item == EMPTY_ITEM


func _set_item(value: Item) -> void:
	item = value
	if is_inside_tree():
		_item_icon.modulate = Color.WHITE
		if item != null:
			_item_icon.texture = value.icon
			_item_icon.modulate = value.icon_modulate
		else:
			item = EMPTY_ITEM


func _on_focus_entered() -> void:
	GuiAudio.play_navigation()


func _on_pressed() -> void:
	GuiAudio.play_select()
