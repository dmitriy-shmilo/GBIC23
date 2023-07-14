class_name EnemyStateInvulnerable
extends StateInvulnerable

@export var audio_player: AudioStreamPlayer2D = null

func enter(args = {}) -> void:
	super.enter(args)
	IMPACT_SFX.play_random_2d(audio_player)
