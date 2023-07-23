class_name PlayerStateInteracting
extends State

var _target = null
var _target_owner = null

func enter(args: Dictionary = {}) -> void:
	_target = args.target
	_target_owner = _target.owner


func physics_process(_delta: float) -> void:
	if _target_owner is Pickup:
		state_machine.transition("Loot", {
			"loot": _target,
			"is_heavy": _target_owner.is_heavy
		})
		return

	if _target_owner is Portal:
		state_machine.transition("Portal", { "portal": _target })
		return
	state_machine.transition("Ready")
