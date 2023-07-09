class_name SfxCollection
extends Resource

@export var items: Array[AudioStream] = []

func play_random(player: AudioStreamPlayer) -> void:
	player.stream = items.pick_random()
	player.play()


func play_random_2d(player: AudioStreamPlayer2D) -> void:
	player.stream = items.pick_random()
	player.play()


