class_name PlayerStateLooting
extends State

@export var looting_period = 0.1
var _current_looting_period = 0.0

# TODO: Must be a component
var _loot: Chest = null

func enter(args: Dictionary = {}) -> void:
	_current_looting_period = 0.0
	_loot = args.loot


func physics_process(delta: float) -> void:
	_current_looting_period += delta
	if _current_looting_period >= looting_period:
		state_machine.transition("Ready")
		_loot.loot()