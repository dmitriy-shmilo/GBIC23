class_name InventoryCell
extends Button

const EMPTY_ITEM = preload("res://items/empty.tres")

@export var item: Item = null: set = _set_item
## Item index within the inventory
@export var index: int = -1

@onready var _item_icon: TextureRect = $"ItemIcon"

func _ready() -> void:
	_set_item(item)
	focus_entered.connect(_on_focus_entered)
	pressed.connect(_on_pressed)


func _set_item(value: Item) -> void:
	item = value
	if is_inside_tree():
		if item != null:
			_item_icon.texture = value.icon
		else:
			item = EMPTY_ITEM


func _on_focus_entered() -> void:
	GuiAudio.play_navigation()


func _on_pressed() -> void:
	GuiAudio.play_select()
