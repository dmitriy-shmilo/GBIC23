class_name PlayerStateCooldown
extends StateCooldown

@export var interactor: InteractorComponent = null
@export var vitals: VitalsComponent = null

func enter(args = {}) -> void:
	super.enter(args)
	if vitals.current_food < vitals.max_food / 4:
		total_time *= 2
	elif vitals.current_food < vitals.max_food / 2:
		total_time *= 1.5


func physics_process(delta: float) -> void:
	if interactor.has_target() and Input.is_action_just_pressed("interact"):
		state_machine.transition("Interact", { "target": interactor.current_target })
	super.physics_process(delta)
