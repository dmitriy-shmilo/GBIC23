class_name PlayerStatePortaling
extends State

func enter(args: Dictionary = {}) -> void:
	state_machine.transition("Ready")
