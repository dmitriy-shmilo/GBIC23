class_name Item
extends Resource

@export var loc_name = ""
@export var loc_description = ""
@export var icon: Texture = null
@export var icon_modulate: Color = Color.WHITE
@export var is_junk = false


func get_item_name() -> String:
	return tr(loc_name)


func get_item_description() -> String:
	return tr(loc_description)
