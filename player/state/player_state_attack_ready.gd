class_name PlayerStateAttackReady
extends State

@export var interactor: InteractorComponent = null

func physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		state_machine.transition("Attack")
		return

	if interactor.has_target() and Input.is_action_just_pressed("interact"):
		state_machine.transition("Loot", { "loot": interactor.current_target })
