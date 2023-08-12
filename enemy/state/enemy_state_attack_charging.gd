class_name EnemyStateAttackTelegraph
extends State

const blink_shader: ShaderMaterial = preload("res://base/shader/blink.tres")

@export var movement: MovementComponent = null
@export var telegraph_time: float = 1.0
@export var sprite: Node2D = null

var _current_telegraph_time: float = 0.0

func enter(_args: Dictionary = {}) -> void:
	sprite.material = blink_shader
	movement.is_busy = true


func exit() -> void:
	movement.is_busy = false
	sprite.material = null
	_current_telegraph_time = 0.0


func physics_process(delta: float) -> void:
	_current_telegraph_time += delta

	if _current_telegraph_time >= telegraph_time:
		state_machine.transition("Attack")
