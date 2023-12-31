class_name EnemyStateAttackReady
extends State


@export var target_area: Area2D = null


func enter(_args: Dictionary = {}) -> void:
	target_area.monitoring = true


func exit() -> void:
	target_area.monitoring = false


func physics_process(_delta: float) -> void:
	if target_area.has_overlapping_bodies():
		state_machine.transition("Telegraph")
