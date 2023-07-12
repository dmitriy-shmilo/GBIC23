class_name InventoryGrid
extends ScrollContainer

signal cell_highlighted(cell)
signal cell_selected(cell)

const EMPTY_ITEM = preload("res://items/empty.tres")
const INVENTORY_CELL_SCENE = preload("res://gui/inventory_cell.tscn")

@export var inventory: InventoryComponent = null: set = set_inventory

@onready var _inventory_grid: GridContainer = $"CenterContainer/InventoryGrid"

func _ready() -> void:
	set_inventory(inventory)


func focus_first_cell() -> void:
	_inventory_grid.get_child(0).grab_focus()


func set_inventory(value) -> void:
	if value == inventory:
		return
	if inventory != null:
		inventory.changed.disconnect(_on_inventory_changed)
	inventory = value
	inventory.changed.connect(_on_inventory_changed)
	_on_inventory_changed(inventory)


func _on_inventory_changed(_inventory: InventoryComponent) -> void:
	var existing_count = _inventory_grid.get_child_count()
	if existing_count < inventory.total_slots():
		for i in range(existing_count):
			_inventory_grid.get_child(i).visible = true

		for i in range(inventory.total_slots() - existing_count):
			var cell = INVENTORY_CELL_SCENE.instantiate() as InventoryCell
			_inventory_grid.add_child(cell)
			cell.focus_entered.connect(_on_inventory_button_focus_entered.bind(cell))
			cell.pressed.connect(_on_inventory_button_pressed.bind(cell))
	else:
		for i in range(inventory.total_slots(), existing_count):
			_inventory_grid.get_child(i).visible = false

	for i in range(inventory.items.size()):
		var item = inventory.items[i]
		var cell = _inventory_grid.get_child(i)
		cell.item = item
		cell.index = i

	for i in range(inventory.items.size(), inventory.max_items):
		var cell = _inventory_grid.get_child(i)
		cell.item = EMPTY_ITEM
		cell.index = i


func _on_inventory_button_focus_entered(cell: InventoryCell) -> void:
	cell_highlighted.emit(cell)


func _on_inventory_button_pressed(cell: InventoryCell) -> void:
	if cell.item == EMPTY_ITEM:
		cell.button_pressed = false
		return

	cell_selected.emit(cell)
