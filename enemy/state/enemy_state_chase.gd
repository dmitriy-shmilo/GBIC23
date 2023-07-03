class_name EnemyStateChase
extends EnemyStateMove

@export var aggro_area: AggroArea = null

var _closest_body: CharacterBody2D = null
var _closest_distance: float = 0.0

func _ready() -> void:
	aggro_area.connect("body_entered", _on_aggro_area_body_entered)
	aggro_area.connect("body_exited", _on_aggro_area_body_exited)


func enter() -> void:
	_refresh_closest_body()


func physics_process(delta: float) -> void:
	target = _closest_body.global_position
	super.physics_process(delta)


func _refresh_closest_body() -> void:
	var bodies = aggro_area.get_overlapping_bodies()
	if bodies.is_empty():
		state_machine.transition("Wonder")
		return

	var position = body.global_position
	_closest_distance = position.distance_squared_to(bodies[0].global_position)
	_closest_body = bodies[0]

	for b in bodies:
		var d = position.distance_squared_to(b.global_position)
		if d < _closest_distance:
			_closest_body = b
			_closest_distance = d


func _on_aggro_area_body_entered(body: CharacterBody2D) -> void:
	_refresh_closest_body()


func _on_aggro_area_body_exited(body: CharacterBody2D) -> void:
	_refresh_closest_body()
