class_name EnemyStateIdle
extends State

@export var body: CharacterBody2D
@export var movement: MovementComponent

func physics_process(delta: float) -> void:
	if body.velocity != Vector2.ZERO:
		body.velocity = body.velocity.move_toward(
			Vector2.ZERO, movement.decelration * delta)
	body.move_and_slide()

	# TODO: pick a target and move
	var dx = 0
	var dy = 0

	if dx != 0 or dy != 0:
		state_machine.transition("Move")

