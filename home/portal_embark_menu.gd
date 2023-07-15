class_name PortalEmbarkMenu
extends ShopMenu

# TODO: pass full embark options
@export var cost = 0

@onready var _storage_inventory_grid: InventoryGrid = $"ScrollContainer/MarginContainer/VBoxContainer/StorageInventoryGrid"
@onready var _pockets_inventory_grid: InventoryGrid = $"ScrollContainer/MarginContainer/VBoxContainer/PocketsInventoryGrid"
@onready var _embark_button: BetterButton = $"ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/EmbarkButton"

var _storage_inventory: InventoryComponent
var _pockets_inventory: InventoryComponent

func _ready() -> void:
	super._ready()
	await owner.ready
	_storage_inventory = owner.storage_inventory
	_pockets_inventory = owner.pockets_inventory
	_pockets_inventory.changed.connect(_on_pockets_inventory_changed)

	_storage_inventory_grid.item_filter = func(i): return i is Consumable
	_storage_inventory_grid.inventory = _storage_inventory
	_pockets_inventory_grid.inventory = _pockets_inventory


func enter() -> void:
	super.enter()
	_storage_inventory_grid.call_deferred("focus_first_cell")


func _on_inventory_grid_cell_highlighted(cell: InventoryCell) -> void:
	if cell.is_empty():
		message_shown.emit("")
		return
	var text = "%s\n%s" % [cell.item.get_item_name().capitalize(),
		cell.item.get_item_description()]
	message_shown.emit(text)


func _on_storage_inventory_grid_cell_selected(cell) -> void:
	cell.button_pressed = false
	if not _pockets_inventory.has_space():
		return
	_pockets_inventory.add_item(cell.item)
	_storage_inventory.remove_item(cell.index)


func _on_pockets_inventory_grid_cell_selected(cell) -> void:
	cell.button_pressed = false
	_storage_inventory.add_item(cell.item)
	_pockets_inventory.remove_item(cell.index)


func _on_pockets_inventory_changed(inventory: InventoryComponent) -> void:
	if inventory.is_empty():
		_embark_button.text = tr("ui_portal_embark_empty")
		_embark_button.loc_hint = "hint_portal_embark_empty"
	else:
		_embark_button.text = tr("ui_portal_embark")
		_embark_button.loc_hint = "hint_portal_embark"


func _on_embark_button_pressed() -> void:
	SaveManager.data.money -= cost
	get_tree().change_scene_to_file("res://main.tscn")


func _on_back_button_pressed() -> void:
	_storage_inventory.add_items(_pockets_inventory.items)
	_pockets_inventory.clear()
	super._on_back_button_pressed()
