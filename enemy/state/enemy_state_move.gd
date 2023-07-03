class_name EnemyStateMove
extends State

signal direction_changed(direction)

@export var next_state: State = null
@export var body: CharacterBody2D = null
@export var movement: MovementComponent = null

## Movement target, in global coordinates.
var target: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.ZERO

const DISTANCE_THRESHOLD = 64.0


func physics_process(delta: float) -> void:
	var direction = target - body.global_position
	direction.x = sign(direction.x)
	direction.y = sign(direction.y)
	direction = direction.normalized()

	if _direction != direction:
		_direction = direction
		direction_changed.emit(direction)

	if body.global_position.distance_squared_to(target) <= DISTANCE_THRESHOLD:
		if next_state != null:
			state_machine.transition(next_state.name)
		return

	body.velocity = body.velocity.move_toward(
		_direction * movement.max_speed,
		movement.acceleration * delta)
	body.move_and_slide()
