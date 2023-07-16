class_name PlayerStateAttacking
extends State

@export var attack_duration = 1.0
@export var hit_box: Area2D = null

var _current_attack_duration = 0.0

func enter(_args: Dictionary = {}) -> void:
	hit_box.monitorable = true
	hit_box.visible = true
	_current_attack_duration = 0.0


func exit() -> void:
	hit_box.monitorable = false
	hit_box.visible = false


func physics_process(delta: float) -> void:
	_current_attack_duration += delta
	if _current_attack_duration >= attack_duration:
		_current_attack_duration = 0.0
		state_machine.transition("Cooldown")
