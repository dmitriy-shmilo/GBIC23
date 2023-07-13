class_name ItemContainer
extends Item

@export var opened_icon: Texture = null: get = get_opened_icon
@export var contents: Array[Item] = []

func get_opened_icon() -> Texture:
	if opened_icon == null:
		return icon
	return opened_icon
