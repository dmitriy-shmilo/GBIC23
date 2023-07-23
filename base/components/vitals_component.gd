class_name VitalsComponent
extends Node


signal health_changed(vitals, is_positive)
signal food_changed(vitals, is_positive)

@export var max_health = 100.0 : set = _set_max_health
@export var current_health = 100.0 : set = _set_current_health
@export var max_food = 100.0 : set = _set_max_food
@export var current_food = 100.0 : set = _set_current_food
@export var food_consumption_rate = 0.5
@export var needs_food = false


var _max_hp_upgrades: Array[ShopUpgrade] = [
	preload("res://items/upgrades/armor_1.tres"),
	preload("res://items/upgrades/armor_2.tres"),
	preload("res://items/upgrades/armor_3.tres"),
	preload("res://items/upgrades/armor_4.tres")
]

var _max_hp_values: Array[int] = [
	1,
	2,
	2,
	4
]

var _max_food_upgrades: Array[ShopUpgrade] = [
	preload("res://items/upgrades/max_food_2.tres"),
	preload("res://items/upgrades/max_food_3.tres"),
	preload("res://items/upgrades/max_food_4.tres"),
]

var _max_food_values: Array[int] = [
	50,
	25,
	25
]

func apply_consumable(item: Consumable) -> void:
	match item.type:
		Consumable.ConsumableType.HEALTH:
			current_health = clamp(current_health + item.strength, 0, max_health)
		Consumable.ConsumableType.FOOD:
			current_food = clamp(current_food + item.strength * max_food, 0, max_food)


func apply_upgrades(upgrades: Array[ShopUpgrade]) -> void:
	for i in range(_max_hp_upgrades.size()):
		if upgrades.has(_max_hp_upgrades[i]):
			max_health += _max_hp_values[i]
	current_health = max_health

	for i in range(_max_food_upgrades.size()):
		if upgrades.has(_max_food_upgrades[i]):
			max_food += _max_food_values[i]
	current_food = max_food


func _set_max_health(h):
	var positive = max_health < h
	max_health = h
	health_changed.emit(self, positive)


func _set_current_health(h):
	var positive = current_health < h
	current_health = h
	health_changed.emit(self, positive)


func _set_max_food(f):
	var positive = max_food < f
	max_food = f
	food_changed.emit(self, positive)


func _set_current_food(f):
	var change = current_food - f
	current_food = f
	if abs(change) > 0:
		food_changed.emit(self, change < 0)
