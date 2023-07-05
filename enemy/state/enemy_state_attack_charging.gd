class_name EnemyStateAttackTelegraph
extends State

@export var telegraph_time: float = 1.0
@export var sprite: Node2D = null

var _current_telegraph_time: float = 0.0

func enter(args: Dictionary = {}) -> void:
	_current_telegraph_time = 0.0
	sprite.modulate = Color.ORANGE_RED


func exit() -> void:
	sprite.modulate = Color.WHITE


func physics_process(delta: float) -> void:
	_current_telegraph_time += delta

	if _current_telegraph_time >= telegraph_time:
		state_machine.transition("Attack")
