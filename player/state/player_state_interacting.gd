class_name PlayerStateInteracting
extends State

func enter(args: Dictionary = {}) -> void:
	var target = args.target
	var owner = target.owner

	if owner is Pickup:
		state_machine.transition("Loot", { "loot": target })
		return

	if owner is Portal:
		state_machine.transition("Portal", { "portal": target })
		return
	state_machine.transition("Ready")
