class_name EnemyStateIdle
extends State

@export var body: CharacterBody2D = null
@export var movement: MovementComponent = null
@export var aggro_area: AggroArea = null
## Seconds before a wonder transition
@export var time_to_wonder: float = 0.0

var _current_idle_time = 0.0

func enter(_args: Dictionary = {}) -> void:
	_current_idle_time = 0.0


func physics_process(delta: float) -> void:
	if body.velocity != Vector2.ZERO:
		body.velocity = body.velocity.move_toward(
			Vector2.ZERO, movement.decelration * delta)
	body.move_and_slide()

	_current_idle_time += delta
	if _current_idle_time >= time_to_wonder:
		state_machine.transition("Wonder")

	if aggro_area.has_overlapping_bodies():
		state_machine.transition("Chase")

