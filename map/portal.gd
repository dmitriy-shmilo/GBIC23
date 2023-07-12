class_name Portal
extends Node2D

@onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
@onready var _inventory: InventoryComponent = $"InventoryComponent"

func _ready() -> void:
	# TODO: setup max count
	_inventory.inventory = SaveManager.data.portal_storage


func _on_go_home_interactive_target_changed(_interactor, targets) -> void:
	_animation_player.play("highlight" if targets else "RESET")
