class_name PlayerStateMove
extends State

signal direction_changed(direction: Vector2)

@export var body: CharacterBody2D
@export var movement: MovementComponent

var _direction := Vector2.ZERO

func physics_process(delta: float) -> void:
	var dx = Input.get_action_strength("move_right") \
	- Input.get_action_strength("move_left")
	var dy = Input.get_action_strength("move_down") \
	- Input.get_action_strength("move_up")

	var direction = Vector2(dx, dy).normalized()

	if _direction != direction:
		_direction = direction
		direction_changed.emit(direction)

	if _direction == Vector2.ZERO:
		state_machine.transition("Idle")

	# TODO: accelerate faster if the direction doesn't match current one
	body.velocity = body.velocity.move_toward(
		_direction * movement.max_speed,
		movement.acceleration * delta)
	body.move_and_slide()

