class_name Item
extends Resource

@export var loc_name = ""
@export var loc_description = ""
@export var icon: Texture = null
@export var icon_modulate: Color = Color.WHITE
@export var is_junk = false
@export var price_modifier = 0

var _purchase_price = -1
var _sell_price = -1

func get_item_name() -> String:
	return tr(loc_name)


func get_item_description() -> String:
	return tr(loc_description)


func get_purchase_price() -> int:
	if _purchase_price < 0:
		_purchase_price = _calculate_purchase_price()
	return _purchase_price


func get_selling_price() -> int:
	if _sell_price < 0:
		_sell_price = _calculate_sell_price()
	return _sell_price


func _calculate_purchase_price() -> int:
	return 0


func _calculate_sell_price() -> int:
	return 0
