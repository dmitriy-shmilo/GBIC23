class_name SaveData
extends Resource

signal money_changed(old, new)

## Current player cash, can be negative
@export var money = 0: set = set_money


func set_money(value: int) -> void:
	var old = money
	money = value
	money_changed.emit(old, money)
