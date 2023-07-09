class_name PlayerStateInteracting
extends State

func enter(args: Dictionary = {}) -> void:
	var target = args.target
	var target_owner = target.owner

	if target_owner is Pickup:
		state_machine.transition("Loot", { "loot": target })
		return

	if target_owner is Portal:
		state_machine.transition("Portal", { "portal": target })
		return
	state_machine.transition("Ready")
