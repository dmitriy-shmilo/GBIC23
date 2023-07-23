class_name PlayerStateDying
extends StateVitalsDying

const PORTAL_SFX: SfxCollection = preload("res://assets/sfx/portal.tres")

@export var audio_player: AudioStreamPlayer = null
@export var particles: GPUParticles2D = null
@export var vitals: VitalsComponent = null

func enter(args = {}) -> void:
	super.enter(args)
	vitals.food_consumption_rate = 0.0
	particles.emitting = true
	PORTAL_SFX.play_random(audio_player)


func exit() -> void:
	super.exit()
	particles.emitting = false


func physics_process(delta: float) -> void:
	_current_time += delta

	if _current_time >= dying_time:
		_current_time = 0.0
		state_machine.transition("Dead")

