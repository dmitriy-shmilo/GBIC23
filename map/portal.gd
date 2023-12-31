class_name Portal
extends Node2D

signal screen_entered()
signal screen_exited()

@onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
@onready var _inventory: InventoryComponent = $"InventoryComponent"
@onready var _hint_label: Label = $"Hint"
var _upgrades = {
	preload("res://items/upgrades/portal_storage_1.tres"): 1,
	preload("res://items/upgrades/portal_storage_2.tres"): 1,
	preload("res://items/upgrades/portal_storage_3.tres"): 1,
	preload("res://items/upgrades/portal_storage_4.tres"): 2,
}

func _ready() -> void:
	var size = 1
	for up in SaveManager.data.upgrades:
		size += _upgrades.get(up, 0)

	_inventory.inventory = SaveManager.data.portal_inventory
	_inventory.max_items = size

	var key: InputEvent = InputMap.action_get_events("interact")[0]
	_hint_label.text = "%s [%s]" % [tr("ui_go_home"), key.as_text()]


func _on_go_home_interactive_target_changed(_interactor, targets) -> void:
	_animation_player.play("highlight" if targets else "RESET")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	screen_entered.emit()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	screen_exited.emit()
