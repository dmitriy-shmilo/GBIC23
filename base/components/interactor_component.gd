class_name InteractorComponent
extends Area2D

signal target_changed(current_target)

var current_target: InteractiveComponent = null
var _closest_distance: float = 0.0

func has_target() -> bool:
	return current_target != null


func refresh() -> void:
	_refresh_closest_target()


func _refresh_closest_target() -> void:
	var targets = get_overlapping_areas()
	if targets.is_empty():
		if current_target != null:
			current_target.set_target(null, false)
			target_changed.emit(null)
			current_target = null
		return

	_closest_distance = global_position.distance_squared_to(targets[0].global_position)
	var closest_target: InteractiveComponent = targets[0]

	for t in targets:
		var d = position.distance_squared_to(t.global_position)
		if d < _closest_distance:
			closest_target = t
			_closest_distance = d

	if current_target != closest_target:
		if current_target != null:
			current_target.set_target(null, false)
		closest_target.set_target(self, true)
		current_target = closest_target
		target_changed.emit(current_target)


func _on_refresh_timer_timeout() -> void:
	_refresh_closest_target()


func _on_area_entered(_area: Area2D) -> void:
	_refresh_closest_target()


func _on_area_exited(_area: Area2D) -> void:
	_refresh_closest_target()
