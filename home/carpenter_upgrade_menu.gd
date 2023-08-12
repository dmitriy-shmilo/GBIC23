class_name CarpenterUpgradeMenu
extends ShopMenu

var _upgrades: Array[ShopUpgrade] = [
	preload("res://items/upgrades/storage_1.tres"),
	preload("res://items/upgrades/storage_2.tres"),
	preload("res://items/upgrades/storage_3.tres"),
	preload("res://items/upgrades/storage_4.tres"),

	preload("res://items/upgrades/up_money_storage_1.tres"),
	preload("res://items/upgrades/up_money_storage_2.tres"),
	preload("res://items/upgrades/up_money_storage_3.tres"),
	preload("res://items/upgrades/up_money_storage_4.tres"),

	preload("res://items/upgrades/counter_1.tres"),
	preload("res://items/upgrades/counter_2.tres"),
	preload("res://items/upgrades/counter_3.tres"),

	preload("res://items/upgrades/up_quest_board_1.tres"),
	preload("res://items/upgrades/up_quest_board_2.tres"),
	preload("res://items/upgrades/up_quest_board_3.tres"),

	preload("res://items/upgrades/cannery_1.tres"),
	preload("res://items/upgrades/cannery_2.tres")
]

@onready var _upgrade_grid: UpgradeGrid = $"ScrollContainer/MarginContainer/VBoxContainer/CenterContainer/UpgradeGrid"


func _ready() -> void:
	super._ready()
	_upgrade_grid.upgrades = _upgrades


func enter() -> void:
	super.enter()
	_upgrade_grid.focus_first_cell()


func _on_upgrade_grid_cell_highlighted(cell: UpgradeCell) -> void:
	message_shown.emit(cell.upgrade.get_rich_description())


func _on_upgrade_grid_upgrade_purchased(_cell) -> void:
	SaveManager.data.refresh_space()
