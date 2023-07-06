class_name EnemyStateWonder
extends EnemyStateMove

@export var radius: float = 48.0
@export var aggro_area: AggroArea = null

var _anchor_point: Vector2 = Vector2.ZERO

func _ready() -> void:
	_anchor_point = body.global_position


func enter(args: Dictionary = {}) -> void:
	var dx = randf() * radius * 2 - radius
	var dy = randf() * radius * 2 - radius
	target = _anchor_point + Vector2(dx, dy)


func physics_process(delta: float) -> void:
	if aggro_area.has_overlapping_bodies():
		state_machine.transition("Chase")
	super.physics_process(delta)
