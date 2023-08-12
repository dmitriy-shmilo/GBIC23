class_name BarracksUpgradeMenu
extends ShopMenu

@onready var _upgrade_grid: UpgradeGrid = $"ScrollContainer/MarginContainer/VBoxContainer/CenterContainer/UpgradeGrid"


func enter() -> void:
	super.enter()
	_upgrade_grid.focus_first_cell()


func _on_upgrade_grid_cell_highlighted(cell: UpgradeCell) -> void:
	if cell.position.y + _upgrade_grid.get_parent().position.y < _scroll_container.scroll_vertical:
		_scroll_container.scroll_vertical = int(cell.position.y)
	message_shown.emit(cell.upgrade.get_rich_description())


func _on_upgrade_grid_upgrade_purchased(_cell: UpgradeCell) -> void:
	SaveManager.data.refresh_space()
