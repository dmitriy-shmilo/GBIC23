class_name PauseGui
extends Control

const EMPTY_ITEM = preload("res://items/empty.tres")
const INVENTORY_CELL_SCENE = preload("res://gui/inventory_cell.tscn")

@export var player_inventory: InventoryComponent = null
@export var portal_inventory: InventoryComponent = null

@onready var _pockets_inventory: InventoryComponent = $"PocketsInventoryComponent"
@onready var _inventory_grid: GridContainer = $"%InventoryGrid"
@onready var _context_menu: PanelContainer = $"%ContextMenu"
@onready var _use_button: Button = $"%UseButton"
@onready var _context_cancel_button: Button = %ContextCancelButton
@onready var _item_name: Label = $"%ItemNameLabel"
@onready var _item_description: RichTextLabel = $"%ItemDescriptionLabel"


var _should_play_sfx = false
var _last_cell: InventoryCell = null
var _is_portal = false

func _ready() -> void:
	_pockets_inventory.inventory = SaveManager.data.pockets_inventory
	visible = false
	_context_menu.visible = false


func enter(is_portal: bool) -> void:
	_is_portal = is_portal
	_hide_context_menu()
	visible = true
	get_tree().paused = true
	_inventory_grid.get_child(0).call_deferred("grab_focus")
	set_deferred("_should_play_sfx", true)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and visible:
		if _should_play_sfx:
			GuiAudio.play_cancel()
		visible = false
		get_tree().paused = false
		get_viewport().set_input_as_handled()


func _show_context_menu(cell: InventoryCell) -> void:
	_context_menu.size = Vector2.ZERO
	_last_cell = cell

	if cell.item is Consumable:
		_use_button.disabled = false
		_use_button.focus_mode = Control.FOCUS_ALL
	else:
		_use_button.disabled = true
		_use_button.focus_mode = Control.FOCUS_NONE

	_context_menu.global_position = cell.global_position + Vector2(8.0, 8.0)
	_context_menu.visible = true
	_context_cancel_button.grab_focus()


func _hide_context_menu() -> void:
	_context_menu.visible = false
	if _last_cell != null:
		_should_play_sfx = false
		_last_cell.grab_focus()
		_last_cell.button_pressed = false
		_should_play_sfx = true


func _on_inventory_grid_cell_highlighted(cell) -> void:
	_item_name.text = tr(cell.item.loc_name).capitalize()
	if cell.item is Ingredient:
		_item_description.text = cell.item.get_rich_description()
	else:
		_item_description.text = tr(cell.item.loc_description)


func _on_inventory_grid_cell_selected(cell) -> void:
	_show_context_menu(cell)


func _on_context_cancel_button_pressed() -> void:
	GuiAudio.play_cancel()
	_hide_context_menu()


func _on_drop_button_pressed() -> void:
	if _last_cell == null or _last_cell.index < 0:
		# sanity check, shouldn't happen
		return

	if _should_play_sfx:
		GuiAudio.play_cancel()

	player_inventory.drop_item(_last_cell.index)
	_hide_context_menu()


func _on_use_button_pressed() -> void:
	if _last_cell == null or _last_cell.index < 0:
		return

	player_inventory.use_item(_last_cell.index)
	_hide_context_menu()


func _on_close_button_pressed() -> void:
	if _should_play_sfx:
		GuiAudio.play_select()

	visible = false
	get_tree().paused = false


func _on_button_focus_entered() -> void:
	if _should_play_sfx:
		GuiAudio.play_navigation()

