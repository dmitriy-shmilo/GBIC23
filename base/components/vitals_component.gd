class_name VitalsComponent
extends Node

const BASE_ATTACK_COST = 8.0
const BASE_ATTACK_COOLDOWN = 1.0

signal health_changed(vitals, is_positive)
signal food_changed(vitals, is_positive)

@export var max_health = 100.0 : set = _set_max_health
@export var current_health = 100.0 : set = _set_current_health
@export var max_food = 160.0 : set = _set_max_food
@export var current_food = 160.0 : set = _set_current_food
@export var food_consumption_rate = 0.5
@export var food_efficiency = 0.33
@export var needs_food = false
@export var attack_stamina_cost = BASE_ATTACK_COST
@export var attack_cooldown = BASE_ATTACK_COOLDOWN

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
	80,
	40,
	40
]

var _food_efficiency_upgrades: Array[ShopUpgrade] = [
	preload("res://items/upgrades/max_food_1.tres"),
	preload("res://items/upgrades/max_food_3.tres"),
	preload("res://items/upgrades/max_food_4.tres"),
]

var _food_efficiencies = [
	0.5,
	0.75,
	0.9
]

var _cooldown_upgrades: Array[ShopUpgrade] = [
	preload("res://items/upgrades/dexterity_1.tres"),
	preload("res://items/upgrades/dexterity_3.tres"),
	preload("res://items/upgrades/dexterity_4.tres"),
]

var _attack_stamina_upgrades: Array[ShopUpgrade] = [
	preload("res://items/upgrades/dexterity_2.tres"),
	preload("res://items/upgrades/dexterity_4.tres"),
]

func apply_consumable(item: Consumable) -> void:
	match item.type:
		Consumable.ConsumableType.HEALTH:
			current_health = clamp(current_health + item.strength, 0, max_health)
		Consumable.ConsumableType.FOOD:
			current_food = clamp(current_food + food_efficiency * max_food, 0, max_food)


func apply_upgrades(upgrades: Array[ShopUpgrade]) -> void:
	for i in range(_max_hp_upgrades.size()):
		if upgrades.has(_max_hp_upgrades[i]):
			max_health += _max_hp_values[i]
	current_health = max_health

	for i in range(_max_food_upgrades.size()):
		if upgrades.has(_max_food_upgrades[i]):
			max_food += _max_food_values[i]
	current_food = max_food

	attack_stamina_cost = BASE_ATTACK_COST
	for up in _attack_stamina_upgrades:
		if upgrades.has(up):
			attack_stamina_cost /= 3.0

	attack_cooldown = BASE_ATTACK_COOLDOWN
	for up in _cooldown_upgrades:
		if upgrades.has(up):
			attack_cooldown -= 0.25

	for i in range(_food_efficiency_upgrades.size()):
		if upgrades.has(_food_efficiency_upgrades[i]):
			food_efficiency = _food_efficiencies[i]


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
