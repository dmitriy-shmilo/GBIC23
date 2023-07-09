class_name Portal
extends Node2D

@onready var _animation_player: AnimationPlayer = $"AnimationPlayer"


func _on_go_home_interactive_target_changed(_interactor, targets) -> void:
	_animation_player.play("highlight" if targets else "RESET")
