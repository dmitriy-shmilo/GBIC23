class_name UpgradeGrid
extends GridContainer

signal cell_highlighted(cell)
signal cell_selected(cell)
signal upgrade_purchased(cell)

const UPGRADE_CELL = preload("res://gui/upgrade_cell.tscn")

@export var upgrades: Array[ShopUpgrade] = []: set = set_upgrades


func _ready() -> void:
	set_upgrades(upgrades)


func set_upgrades(value: Array[ShopUpgrade]) -> void:
	upgrades = value
	if is_inside_tree():
		_invalidate_grid()


func refresh() -> void:
	_invalidate_grid()


func _invalidate_grid() -> void:
	var existing_count = get_child_count()
	var up_count = upgrades.size()

	# add missing cells
	if existing_count < up_count:
		for i in range(existing_count, up_count):
			var cell = UPGRADE_CELL.instantiate()
			cell.selected.connect(_on_cell_selected.bind(cell))
			cell.highlighted.connect(_on_cell_highlighted.bind(cell))
			add_child(cell)
	else:
		for i in range(up_count, existing_count):
			# TODO: clear out the upgrade property
			get_child(i).visible = false


	for i in range(up_count):
		var upgrade = upgrades[i]
		var cell = get_child(i) as UpgradeCell
		cell.visible = true
		cell.upgrade = upgrade
		cell.disabled =  not _can_buy(upgrade)
		cell.purchased = SaveManager.data.upgrades.has(upgrade)


func _on_cell_selected(cell: UpgradeCell) -> void:
	cell_selected.emit(cell)
	SaveManager.data.upgrades.push_back(cell.upgrade)
	SaveManager.data.money -= cell.upgrade.base_price
	upgrade_purchased.emit(cell)
	_invalidate_grid()


func _on_cell_highlighted(cell: UpgradeCell) -> void:
	cell_highlighted.emit(cell)


func _can_buy(upgrade: ShopUpgrade) -> bool:
	if SaveManager.data.upgrades.has(upgrade):
		return false

	if SaveManager.data.money < upgrade.base_price:
		return false

	for preq in upgrade.prerequisites:
		if not SaveManager.data.upgrades.has(preq):
			return false

	return true
