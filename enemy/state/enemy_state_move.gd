class_name EnemyStateMove
extends State

const DISTANCE_THRESHOLD = 64.0
const MOVEMENT_THRESHOLD = 64.0

signal direction_changed(direction)

## State to transition to when the movement is considered complete.
@export var next_state: State = null
## State to transition to when the movement is considered stuck.
@export var unstuck_state: State = null
@export var body: CharacterBody2D = null
@export var movement: MovementComponent = null
## How often, in seconds the state will compare its current
## position to the previous one.
@export var position_snapshot_interval = 1.0

## Movement target, in global coordinates.
var _target: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.ZERO
var _time_since_snapshot = 0.0
var _last_position_snapshot = Vector2.ZERO

func enter(args = {}) -> void:
	_time_since_snapshot = 0.0
	_target = args.target


func physics_process(delta: float) -> void:
	_time_since_snapshot += delta
	if _time_since_snapshot >= position_snapshot_interval:
		_time_since_snapshot = 0.0
		if _last_position_snapshot.distance_squared_to(body.global_position) > MOVEMENT_THRESHOLD or unstuck_state == null:
			_last_position_snapshot = body.global_position
		else:
			state_machine.transition(unstuck_state.name)
			return

	var direction = (_target - body.global_position).normalized()

	if _direction != direction:
		_direction = direction
		direction_changed.emit(direction)

	if body.global_position.distance_squared_to(_target) <= DISTANCE_THRESHOLD:
		if next_state != null:
			state_machine.transition(next_state.name)
		return

	body.velocity = body.velocity.move_toward(
		direction * movement.max_speed,
		movement.acceleration * delta)
	body.move_and_slide()
