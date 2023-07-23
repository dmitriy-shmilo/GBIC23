class_name PlayerStateIdle
extends State

@export var body: CharacterBody2D = null
@export var movement: MovementComponent = null
@export var vitals: VitalsComponent = null

func enter(_args = {}) -> void:
	vitals.food_consumption_rate = 0.5


func physics_process(delta: float) -> void:
	if body.velocity != Vector2.ZERO:
		body.velocity = body.velocity.move_toward(
			Vector2.ZERO, movement.decelration * delta)
	body.move_and_slide()

	var dx = Input.get_action_strength("move_right") \
	- Input.get_action_strength("move_left")
	var dy = Input.get_action_strength("move_down") \
	- Input.get_action_strength("move_up")

	if dx != 0 or dy != 0:
		state_machine.transition("Move")
