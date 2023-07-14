class_name PlayerStateInvulnerable
extends StateInvulnerable

@export var audio_player: AudioStreamPlayer = null

func enter(args = {}) -> void:
	super.enter(args)
	IMPACT_SFX.play_random(audio_player)
