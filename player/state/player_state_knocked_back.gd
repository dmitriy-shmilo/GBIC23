class_name PlayerStateKnockedBack
extends StateKnockedBack

func physics_process(delta: float) -> void:
	super.physics_process(delta)
	if body.velocity.length_squared() <= 0.1:
		state_machine.transition("Idle")
