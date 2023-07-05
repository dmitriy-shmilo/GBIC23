class_name PlayerStateAttackReady
extends State

@export var looter: LooterComponent = null

func physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		state_machine.transition("Attack")
		return

	if looter.has_loot() and Input.is_action_just_pressed("interact"):
		state_machine.transition("Loot")
