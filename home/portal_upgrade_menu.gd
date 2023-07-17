class_name PortalUpgradeMenu
extends ShopMenu

var _upgrades: Array[ShopUpgrade] = [
	preload("res://items/upgrades/portal_license_1.tres"),
	preload("res://items/upgrades/portal_license_2.tres"),
	preload("res://items/upgrades/portal_license_3.tres"),
	preload("res://items/upgrades/portal_storage_1.tres"),
	preload("res://items/upgrades/portal_storage_2.tres"),
	preload("res://items/upgrades/portal_storage_3.tres"),
	preload("res://items/upgrades/portal_storage_4.tres"),
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
