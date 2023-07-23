class_name PlayerStateLooting
extends State

const MAX_INPUT_DELAY = 0.1
signal progress(value)

@export var interactor: InteractorComponent = null
@export var inventory: InventoryComponent = null
@export var looting_period = 1.0
@export var movement: MovementComponent = null

var _total_looting_period = looting_period
var _current_looting_period = 0.0
var _loot: InteractiveComponent = null
var _input_delay = 0.0

func enter(args: Dictionary = {}) -> void:
	# TODO: play a sound
	if not inventory.has_space():
		state_machine.transition("Ready")
		return

	movement.is_busy = true
	_current_looting_period = 0.0
	_loot = args.loot
	_input_delay = 0.0
	_total_looting_period = looting_period if args.is_heavy else looting_period / 4
	progress.emit(0.0)


func exit() -> void:
	movement.is_busy = false


func physics_process(delta: float) -> void:
	_input_delay += delta

	if _loot == null:
		state_machine.transition("Ready")
		return

	if _input_delay > MAX_INPUT_DELAY:
		if Input.is_action_just_pressed("move_down") \
			or Input.is_action_just_pressed("move_left") \
			or Input.is_action_just_pressed("move_right") \
			or Input.is_action_just_pressed("move_up") \
			or Input.is_action_just_pressed("interact"):
				state_machine.transition("Ready")
				return

		if Input.is_action_just_pressed("attack"):
			state_machine.transition("Attack")
			return

	_current_looting_period += delta
	progress.emit(clamp(_current_looting_period / _total_looting_period, 0.0, 1.0))
	if _current_looting_period >= _total_looting_period:
		var pickup = _loot.owner as Pickup
		if pickup.is_picked_up:
			return
		state_machine.transition("Ready")
		inventory.add_item(pickup.item)
		_loot.interact(interactor)
		_loot = null

