class_name EnemyStateDying
extends StateVitalsDying

const DYING_SFX = preload("res://assets/sfx/enemy_death.tres")

@export var audio_player: AudioStreamPlayer2D = null

func enter(args = {}) -> void:
	super.enter(args)
	DYING_SFX.play_random_2d(audio_player )

