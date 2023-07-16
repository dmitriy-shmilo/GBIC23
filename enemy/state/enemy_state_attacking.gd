class_name EnemyStateAttacking
extends State

const SWOOSH_SFX: SfxCollection = preload("res://assets/sfx/swoosh.tres")

@export var audio_player: AudioStreamPlayer2D = null
@export var attack_duration = 1.0
@export var hit_box: Area2D = null

var _current_attack_duration = 0.0

func enter(_args: Dictionary = {}) -> void:
	SWOOSH_SFX.play_random_2d(audio_player)
	hit_box.set_deferred("monitorable", true)
	hit_box.visible = true
	_current_attack_duration = 0.0


func exit() -> void:
	hit_box.visible = false
	hit_box.set_deferred("monitorable", false)


func physics_process(delta: float) -> void:
	_current_attack_duration += delta
	if _current_attack_duration >= attack_duration:
		state_machine.transition("Cooldown")
