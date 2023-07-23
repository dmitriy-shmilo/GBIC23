class_name PlayerStateMove
extends State

signal direction_changed(direction: Vector2)

@export var body: CharacterBody2D = null
@export var movement: MovementComponent = null
@export var vitals: VitalsComponent = null

var _direction := Vector2.ZERO

func enter(_args = {}) -> void:
	vitals.food_consumption_rate = 1.0


func _get_max_speed() -> float:
	var result = movement.max_speed
	if vitals.current_food < vitals.max_food / 8:
		result *= 0.25
	elif vitals.current_food < vitals.max_food / 4:
		result *= 0.5
	elif vitals.current_food < vitals.max_food / 2:
		result *= 0.75

	return result


func physics_process(delta: float) -> void:
	var dx = Input.get_action_strength("move_right") \
	- Input.get_action_strength("move_left")
	var dy = Input.get_action_strength("move_down") \
	- Input.get_action_strength("move_up")

	var direction = Vector2(dx, dy).normalized()

	if _direction != direction:
		_direction = direction
		direction_changed.emit(direction)

	if _direction == Vector2.ZERO or movement.is_busy:
		state_machine.transition("Idle")

	# TODO: accelerate faster if the direction doesn't match current one
	body.velocity = body.velocity.move_toward(
		_direction * _get_max_speed(),
		movement.acceleration * delta)
	body.move_and_slide()

