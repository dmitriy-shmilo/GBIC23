class_name LooterComponent
extends Area2D

signal loot_changed(current_interactive)

# TODO: this should be an interactable component
var current_interactive: CharacterBody2D = null
var _closest_distance: float = 0.0

func has_loot() -> bool:
	return current_interactive != null


func _refresh_closest_body() -> void:
	if current_interactive != null:
		current_interactive.is_highlighted = false

	var bodies = get_overlapping_bodies()
	if bodies.is_empty():
		current_interactive = null
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

	if current_interactive != closest_body:
		current_interactive = closest_body
		loot_changed.emit(current_interactive)


func _on_body_entered(_body: Node2D) -> void:
	_refresh_closest_body()


func _on_body_exited(_body: Node2D) -> void:
	_refresh_closest_body()
