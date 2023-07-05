class_name StateMachine
extends Node

signal transitioned(state_name)

@export var initial_state: State = null
var current_state: State = null

func _ready() -> void:
	current_state = initial_state

	for n in get_children():
		n.state_machine = self


func _process(delta: float) -> void:
	current_state.process(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_process(delta)


func transition(state: String, args: Dictionary = {}) -> void:
	# TODO: cache state nodes
	var new_state: State = get_node(state)
	if not new_state:
		printerr("Can't find state '%s' in state machine '%s'" % [state, get_path()])
		return

	current_state.exit()
	current_state = new_state
	current_state.enter(args)
	emit_signal("transitioned", state)
