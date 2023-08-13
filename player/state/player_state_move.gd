class_name PlayerStateMove
extends State

signal direction_changed(direction: Vector2)
signal terrain_changed(is_in_water: bool)

@export var tile_map: TileMapComponent = null
@export var body: CharacterBody2D = null
@export var movement: MovementComponent = null
@export var vitals: VitalsComponent = null

var _direction := Vector2.ZERO
var _is_in_water := false:
	set(value):
		if _is_in_water != value:
			_is_in_water = value
			terrain_changed.emit(value)


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

	var depth = tile_map.current_tile_depth()

	_is_in_water = depth > 0
	if depth == 1:
		result *= 0.75
	elif depth == 2:
		result *= 0.5
	elif depth == 3:
		result *= 0.25
	elif depth > 3:
		result *= 0.1

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

