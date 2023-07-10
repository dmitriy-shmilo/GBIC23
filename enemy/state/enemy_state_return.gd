class_name EnemyStateReturn
extends EnemyStateMove

var _anchor_point: Vector2 = Vector2.ZERO

func _ready() -> void:
	_anchor_point = body.global_position


func enter(_args: Dictionary = {}) -> void:
	super.enter({ "target": _anchor_point })
