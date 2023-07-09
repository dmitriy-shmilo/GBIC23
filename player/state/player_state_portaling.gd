class_name PlayerStatePortaling
extends State

func enter(_args: Dictionary = {}) -> void:
	state_machine.transition("Ready")
