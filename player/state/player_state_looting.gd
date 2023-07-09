class_name PlayerStateLooting
extends State

@export var interactor: InteractorComponent = null
@export var inventory: InventoryComponent = null
@export var looting_period = 0.1

var _current_looting_period = 0.0
var _loot: InteractiveComponent = null

func enter(args: Dictionary = {}) -> void:
	# TODO: play a sound
	if not inventory.has_space():
		state_machine.transition("Ready")

	_current_looting_period = 0.0
	_loot = args.loot


func physics_process(delta: float) -> void:
	if _loot == null:
		state_machine.transition("Ready")
		return

	_current_looting_period += delta
	if _current_looting_period >= looting_period:
		state_machine.transition("Ready")
		inventory.add_item(_loot.owner.item)
		_loot.interact(interactor)
		_loot = null

