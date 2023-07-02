class_name StateMachine
extends Node

signal transitioned(state_name)

@export var initial_state: State = null
var _current_state: State = null

func _ready() -> void:
	_current_state = initial_state

	for n in get_children():
		n.state_machine = self


func _process(delta: float) -> void:
	_current_state.process(delta)


func _physics_process(delta: float) -> void:
	_current_state.physics_process(delta)


func transition(state: String) -> void:
	# TODO: cache state nodes
	var new_state: State = get_node(state)
	if not new_state:
		printerr("Can't find state '%s' in state machine '%s'" % [state, get_path()])
		return

	_current_state.exit()
	_current_state = new_state
	_current_state.enter()
	emit_signal("transitioned", state)
