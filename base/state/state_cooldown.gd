class_name StateCooldown
extends State

@export var next_state: State = null
@export var time = 0.5

var total_time = time
var _current_time = 0.0

func enter(_args = {}) -> void:
	total_time = time
	_current_time = 0


func physics_process(delta: float) -> void:
	_current_time += delta
	if _current_time > total_time:
		_current_time = 0.0
		state_machine.transition(next_state.name)
