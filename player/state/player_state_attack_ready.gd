class_name PlayerStateAttackReady
extends State



func physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		state_machine.transition("Attack")