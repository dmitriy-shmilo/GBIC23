class_name CounterMenu
extends ShopMenu


@onready var _storage_grid: InventoryGrid = $"ScrollContainer/MarginContainer/VBoxContainer/StorageInventoryGrid"
@onready var _counter_grid: InventoryGrid = $"ScrollContainer/MarginContainer/VBoxContainer/CounterInventoryGrid"
@onready var _sell_button: BetterButton = $"ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/SellButton"

func _ready() -> void:
	super._ready()
	await owner.ready
	_counter_grid.inventory = owner.counter_inventory
	owner.counter_inventory.changed.connect(_on_counter_inventory_changed)
	_storage_grid.inventory = owner.storage_inventory
	_storage_grid.item_filter = func(i): return i is Product


func enter() -> void:
	super.enter()
	_storage_grid.call_deferred("focus_first_cell")


func _on_storage_inventory_grid_cell_selected(cell) -> void:
	cell.button_pressed = false
	if not owner.counter_inventory.has_space():
		return
	owner.counter_inventory.add_item(cell.item)
	owner.storage_inventory.remove_item(cell.index)


func _on_counter_inventory_grid_cell_selected(cell: InventoryCell) -> void:
	cell.button_pressed = false
	owner.storage_inventory.add_item(cell.item)
	owner.counter_inventory.remove_item(cell.index)


func _on_inventory_grid_cell_highlighted(cell: InventoryCell) -> void:
	if cell.is_empty():
		message_shown.emit("")
		return
	var text = "%s\n%s" % [cell.item.get_item_name().capitalize(),
		cell.item.get_item_description()]
	message_shown.emit(text)


func _on_counter_inventory_changed(counter_inventory: InventoryComponent) -> void:
	if counter_inventory.is_empty():
		_sell_button.disabled = true
		_sell_button.loc_hint = "ui_counter_empty"
	else:
		_sell_button.disabled = false
		_sell_button.loc_hint = "ui_counter_sell"


func _on_sell_button_pressed() -> void:
	# TODO: show a summary screen
	# TODO: calculate selling price
	for product in owner.counter_inventory.items:
		if product is Product:
			SaveManager.data.money += 10

	owner.counter_inventory.clear()
