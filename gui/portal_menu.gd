class_name PortalMenu
extends Control

const MAX_INV_HEIGHT = 128
const CONTEXT_MENU_OFFSET = Vector2(8.0, 8.0)
const EMPTY_ITEM = preload("res://items/empty.tres")

@export var player_inventory: InventoryComponent = null
@export var portal_inventory: InventoryComponent = null

@onready var _storage_inventory: InventoryComponent = $"StorageInventoryComponent"
@onready var _context_menu: PanelContainer = $"%ContextMenu"
@onready var _unload_button: Button = $"%UnloadButton"
@onready var _context_cancel_button: Button = %ContextCancelButton
@onready var _item_name: Label = $"%ItemNameLabel"
@onready var _item_description: RichTextLabel = $"%ItemDescriptionLabel"
@onready var _player_inventory_grid: InventoryGrid = $Panel/VBoxContainer/PlayerInventoryGrid
@onready var _portal_inventory_grid: InventoryGrid = $Panel/VBoxContainer/PortalInventoryGrid

var _last_cell: InventoryCell = null

@warning_ignore("integer_division")
func _ready() -> void:
	_player_inventory_grid.inventory = player_inventory
	_portal_inventory_grid.inventory = portal_inventory

	_player_inventory_grid.custom_minimum_size = Vector2(0,
		min(MAX_INV_HEIGHT, player_inventory.total_slots() * 32 / 8))
	_portal_inventory_grid.custom_minimum_size = Vector2(0,
		min(MAX_INV_HEIGHT, player_inventory.total_slots() * 32 / 8))
	_storage_inventory.inventory = SaveManager.data.storage_inventory
	visible = false
	_context_menu.visible = false


func _unhandled_input(event: InputEvent) -> void:
	# TODO: assign shortcuts
	if event.is_action_pressed("pause") and visible:
		visible = false
		get_tree().paused = false
		get_viewport().set_input_as_handled()


func enter() -> void:
	_hide_context_menu()
	visible = true
	get_tree().paused = true
	_player_inventory_grid.focus_first_cell()


func _show_context_menu(cell: InventoryCell, is_pockets: bool) -> void:
	if not is_pockets:
		return

	_context_menu.size = Vector2.ZERO
	_last_cell = cell

	if cell.item is Consumable:
		_unload_button.disabled = true
		_unload_button.focus_mode = Control.FOCUS_NONE
	else:
		_unload_button.disabled = false
		_unload_button.focus_mode = Control.FOCUS_ALL

	_context_cancel_button.grab_focus()
	_context_menu.global_position = cell.global_position + CONTEXT_MENU_OFFSET
	_context_menu.visible = true


func _hide_context_menu() -> void:
	_context_menu.visible = false
	if _last_cell != null:
		_last_cell.grab_focus()
		_last_cell.button_pressed = false


func _on_inventory_grid_cell_highlighted(cell: InventoryCell) -> void:
	_item_name.text = tr(cell.item.loc_name).capitalize()
	if cell.item is Ingredient:
		_item_description.text = cell.item.get_rich_description()
	else:
		_item_description.text = tr(cell.item.loc_description)


func _on_player_inventory_grid_cell_selected(cell: InventoryCell) -> void:
	_show_context_menu(cell, true)


func _on_portal_inventory_grid_cell_selected(cell: InventoryCell) -> void:
	cell.button_pressed = false


func _on_context_cancel_button_pressed() -> void:
	_hide_context_menu()


func _on_drop_button_pressed() -> void:
	if _last_cell == null or _last_cell.index < 0:
		# sanity check, shouldn't happen
		return

	player_inventory.drop_item(_last_cell.index)
	_hide_context_menu()


func _on_close_button_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_go_home_button_pressed() -> void:
	# TODO: return home intermediate screen
	for i in player_inventory.items:
		_storage_inventory.add_item(i)
		if not i is Consumable:
			SaveManager.data.money += 10

	for i in portal_inventory.items:
		_storage_inventory.add_item(i)
		if not i is Consumable:
			SaveManager.data.money += 10

	player_inventory.clear()
	portal_inventory.clear()
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://home/hub.tscn")
	SaveManager.save_data()


func _on_unload_button_pressed() -> void:
	if _last_cell == null or _last_cell.index < 0:
		return

	# TODO: check for portal inventory capacity
	var item = player_inventory.remove_item(_last_cell.index)
	portal_inventory.add_item(item)
	_hide_context_menu()
