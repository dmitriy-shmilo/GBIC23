class_name StateLabel
extends Label

@export var state_machine: StateMachine

func _ready() -> void:
	await get_parent().ready
	state_machine.connect("transitioned", _on_state_machine_transitioned)
	text = state_machine.initial_state.name


func _on_state_machine_transitioned(state: String) -> void:
	text = state
