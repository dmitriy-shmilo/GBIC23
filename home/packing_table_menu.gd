class_name PackingTableMenu
extends ShopMenu

const ITEM_RATION = preload("res://items/consumables/ration.tres")

@onready var _cannery_inventory: InventoryComponent = $"CanneryInventoryComponent"
@onready var _storage_grid: InventoryGrid = $"ScrollContainer/MarginContainer/VBoxContainer/StorageInventoryGrid"
@onready var _cannery_grid: InventoryGrid = $"ScrollContainer/MarginContainer/VBoxContainer/CanneryInventoryGrid"
@onready var _cook_button: BetterButton = $"ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/CookButton"

var _upgrades: Array[ShopUpgrade] = [
	preload("res://items/upgrades/cannery_1.tres"),
	preload("res://items/upgrades/cannery_2.tres")
]

func _ready() -> void:
	super._ready()

	_cannery_inventory.inventory = Inventory.new()
	_cannery_inventory.changed.connect(_on_cannery_inventory_changed)
	_cannery_grid.inventory = _cannery_inventory

	await owner.ready
	_storage_grid.inventory = owner.storage_inventory
	_storage_grid.item_filter = func(i): return i is Ingredient


func enter() -> void:
	super.enter()
	_storage_grid.call_deferred("focus_first_cell")
	for up in _upgrades:
		if SaveManager.data.upgrades.has(up):
			_cannery_inventory.max_items = up.strength
	_on_cannery_inventory_changed(_cannery_inventory)


func _on_cannery_inventory_changed(inventory: InventoryComponent) -> void:
	_cook_button.disabled = inventory.items.size() != inventory.max_items


func _on_inventory_grid_cell_highlighted(cell: InventoryCell) -> void:
	if cell.is_empty():
		message_shown.emit("")
		return
	var text = "%s\n%s" % [cell.item.get_item_name().capitalize(),
		cell.item.get_item_description()]
	message_shown.emit(text)


func _on_storage_inventory_grid_cell_selected(cell) -> void:
	cell.button_pressed = false
	if not _cannery_inventory.has_space():
		return
	_cannery_inventory.add_item(cell.item)
	owner.storage_inventory.remove_item(cell.index)


func _on_kitchen_inventory_grid_cell_selected(cell) -> void:
	cell.button_pressed = false
	owner.storage_inventory.add_item(cell.item)
	_cannery_inventory.remove_item(cell.index)


func _on_back_button_pressed() -> void:
	owner.storage_inventory.add_items(_cannery_inventory.items)
	_cannery_inventory.clear()
	super._on_back_button_pressed()


func _on_cook_button_pressed() -> void:
	_cannery_inventory.clear()
	owner.storage_inventory.add_item(ITEM_RATION)
