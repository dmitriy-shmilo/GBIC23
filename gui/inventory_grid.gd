class_name InventoryGrid
extends Container

signal cell_highlighted(cell: InventoryCell)
signal cell_selected(cell: InventoryCell)

const EMPTY_ITEM = preload("res://items/empty.tres")
const INVENTORY_CELL_SCENE = preload("res://gui/inventory_cell.tscn")


@export var selectable = true
@export var hide_empty_extras = false
@export var inventory: InventoryComponent = null: set = set_inventory

var item_filter: Callable = func(_i): return true: set = set_item_filter

@onready var _inventory_grid: Container = self

var _is_dirty = false

func _ready() -> void:
	set_inventory(inventory)


func focus_first_cell() -> void:
	_inventory_grid.get_child(0).grab_focus()


func set_item_filter(value: Callable) -> void:
	item_filter = value
	if is_inside_tree() and inventory != null:
		_on_inventory_changed(inventory)


func set_inventory(value) -> void:
	if not is_inside_tree():
		inventory = value
		return
	if inventory != null and inventory.changed.is_connected(_on_inventory_changed):
		inventory.changed.disconnect(_on_inventory_changed)
	inventory = value
	if inventory == null:
		return
	inventory.changed.connect(_on_inventory_changed)
	_on_inventory_changed(inventory)


func _on_inventory_changed(_inventory: InventoryComponent) -> void:
	if not visible:
		_is_dirty = true
		return

	var existing_count = _inventory_grid.get_child_count()
	var matching_items = inventory.items.filter(item_filter)

	var total_slots = max(1, matching_items.size())
	if not hide_empty_extras and inventory.max_items > total_slots:
		total_slots = inventory.max_items

	# prepare cells, or hide extra ones
	if existing_count < total_slots:
		for i in range(existing_count):
			_inventory_grid.get_child(i).visible = true

		for i in range(total_slots - existing_count):
			var cell = INVENTORY_CELL_SCENE.instantiate() as InventoryCell
			_inventory_grid.add_child(cell)
			cell.mouse_entered.connect(_on_inventory_button_mouse_entered.bind(cell))
			cell.focus_entered.connect(_on_inventory_button_focus_entered.bind(cell))
			cell.pressed.connect(_on_inventory_button_pressed.bind(cell))
	else:
		# TODO: this loop is not totally necessary
		for i in range(0, total_slots):
			_inventory_grid.get_child(i).visible = true

		for i in range(total_slots, existing_count):
			if _inventory_grid.get_child(i).has_focus() and total_slots > 1:
				_inventory_grid.get_child(total_slots - 1).grab_focus()
			_inventory_grid.get_child(i).visible = false

	# place items
	var i = 0
	var index = 0
	for item in inventory.items:
		if item_filter.call(item):
			var cell = _inventory_grid.get_child(i)
			var old_item = cell.item
			cell.item = item
			cell.index = index
			if item != old_item and cell.has_focus():
				_on_inventory_button_focus_entered(cell)
			i += 1
		index += 1

	# set extra slots as empty items
	for j in range(i, total_slots):
		var cell = _inventory_grid.get_child(j)
		cell.item = EMPTY_ITEM
		cell.index = j


func _on_inventory_button_mouse_entered(cell: InventoryCell) -> void:
	cell_highlighted.emit(cell)


func _on_inventory_button_focus_entered(cell: InventoryCell) -> void:
	cell_highlighted.emit(cell)


func _on_inventory_button_pressed(cell: InventoryCell) -> void:
	if cell.item == EMPTY_ITEM or not selectable:
		cell.button_pressed = false
		return

	cell_selected.emit(cell)


func _on_visibility_changed() -> void:
	if visible and _is_dirty:
		_on_inventory_changed(inventory)
