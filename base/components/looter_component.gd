class_name LooterComponent
extends Area2D

signal loot_changed(closest_loot)

# TODO: this should be an interactable component
var _closest_body: CharacterBody2D = null
var _closest_distance: float = 0.0

func has_loot() -> bool:
	return _closest_body != null


func _refresh_closest_body() -> void:
	if _closest_body != null:
		_closest_body.is_highlighted = false

	var bodies = get_overlapping_bodies()
	if bodies.is_empty():
		_closest_body = null
		loot_changed.emit(null)
		return

	_closest_distance = global_position.distance_squared_to(bodies[0].global_position)
	var closest_body = bodies[0]

	for b in bodies:
		var d = position.distance_squared_to(b.global_position)
		if d < _closest_distance:
			closest_body = b
			_closest_distance = d
	closest_body.is_highlighted = true

	if _closest_body != closest_body:
		_closest_body = closest_body
		loot_changed.emit(_closest_body)


func _on_body_entered(_body: Node2D) -> void:
	_refresh_closest_body()


func _on_body_exited(_body: Node2D) -> void:
	_refresh_closest_body()
