class_name PlayerStateCooldown
extends StateCooldown

@export var interactor: InteractorComponent = null

func physics_process(delta: float) -> void:
	if interactor.has_target() and Input.is_action_just_pressed("interact"):
		state_machine.transition("Interact", { "target": interactor.current_target })
	super.physics_process(delta)
