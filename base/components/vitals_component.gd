class_name VitalsComponent
extends Node

signal health_changed(vitals, is_positive)
signal food_changed(vitals)

@export var max_health = 100.0 : set = _set_max_health
@export var current_health = 100.0 : set = _set_current_health
@export var max_food = 100.0 : set = _set_max_food
@export var current_food = 100.0 : set = _set_current_food
@export var needs_food = false


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
	var positive = current_food < f
	current_food = f
	food_changed.emit(self, positive)
