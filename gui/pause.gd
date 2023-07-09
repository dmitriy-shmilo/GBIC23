class_name PauseGui
extends Control

const EMPTY_ITEM = preload("res://items/empty.tres")
const CANCEL_SFX = preload("res://assets/sfx/cancel.tres")
const MENU_NAVIGATION_SFX = preload("res://assets/sfx/menu_navigation.tres")
const MENU_SELECT_SFX = preload("res://assets/sfx/menu_select.tres")
const INVENTORY_CELL_SCENE = preload("res://gui/inventory_cell.tscn")

@export var inventory: InventoryComponent = null

@onready var _inventory_grid: GridContainer = $"%InventoryGrid"
@onready var _audio_player: AudioStreamPlayer = $"AudioStreamPlayer"
@onready var _context_menu: PanelContainer = $"%ContextMenu"
@onready var _drop_button: Button = $"%DropButton"
@onready var _use_button: Button = $"%UseButton"
@onready var _unload_button: Button = $"%UnloadButton"
@onready var _item_name: Label = $"%ItemNameLabel"
@onready var _item_description: RichTextLabel = $"%ItemDescriptionLabel"
@onready var _go_home_button: Button = $"%GoHomeButton"

var _should_play_sfx = false
var _last_cell: InventoryCell = null
var _is_portal = false

func _ready() -> void:
	visible = false
	inventory.connect("changed", _on_inventory_changed)
	_on_inventory_changed(inventory)
	_context_menu.visible = false


func enter(is_portal: bool) -> void:
	_is_portal = is_portal
	_hide_context_menu()
	visible = true
	get_tree().paused = true
	_inventory_grid.get_child(0).call_deferred("grab_focus")
	set_deferred("_should_play_sfx", true)

	if _is_portal:
		_go_home_button.visible = true
		_use_button.visible = false
		_unload_button.visible = true
	else:
		_go_home_button.visible = false
		_use_button.visible = true
		_unload_button.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if _should_play_sfx:
			_audio_player.stream = MENU_SELECT_SFX.items.pick_random()
			_audio_player.play()
		visible = false
		get_tree().paused = false
		get_viewport().set_input_as_handled()


func _show_context_menu(cell: InventoryCell) -> void:
	_context_menu.size = Vector2.ZERO
	_last_cell = cell

	cell.item is Consumable
	if cell.item is Consumable:
		_use_button.disabled = false
		_unload_button.disabled = true
		_use_button.focus_mode = Control.FOCUS_ALL
		_unload_button.focus_mode = Control.FOCUS_NONE
	else:
		_use_button.disabled = true
		_unload_button.disabled = false
		_use_button.focus_mode = Control.FOCUS_NONE
		_unload_button.focus_mode = Control.FOCUS_ALL

	_context_menu.global_position = cell.global_position + Vector2(8.0, 8.0)
	_context_menu.visible = true

	if _is_portal:
		_unload_button.grab_focus()
	else:
		_drop_button.grab_focus()


func _hide_context_menu() -> void:
	_context_menu.visible = false
	if _last_cell != null:
		_should_play_sfx = false
		_last_cell.grab_focus()
		_last_cell.button_pressed = false
		_should_play_sfx = true


func _on_inventory_changed(_inventory: InventoryComponent) -> void:
	var existing_count = _inventory_grid.get_child_count()
	if existing_count < inventory.max_items:
		for i in range(inventory.max_items - existing_count):
			var cell = INVENTORY_CELL_SCENE.instantiate() as InventoryCell
			_inventory_grid.add_child(cell)
			cell.focus_entered.connect(_on_inventory_button_focus_entered.bind(cell))
			cell.pressed.connect(_on_inventory_button_pressed.bind(cell))

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
	if _should_play_sfx:
		_audio_player.stream = MENU_NAVIGATION_SFX.items.pick_random()
		_audio_player.play()

	_item_name.text = tr(cell.item.loc_name).capitalize()
	_item_description.text = tr(cell.item.loc_description)


func _on_inventory_button_pressed(cell: InventoryCell) -> void:
	if cell.item == EMPTY_ITEM:
		cell.button_pressed = false
		_audio_player.stream = CANCEL_SFX.items.pick_random()
		_audio_player.play()
		return

	if _should_play_sfx:
		_audio_player.stream = MENU_SELECT_SFX.items.pick_random()
		_audio_player.play()

	_show_context_menu(cell)


func _on_context_cancel_button_pressed() -> void:
	_audio_player.stream = CANCEL_SFX.items.pick_random()
	_audio_player.play()
	_hide_context_menu()


func _on_drop_button_pressed() -> void:
	if _last_cell == null or _last_cell.index < 0:
		# sanity check, shouldn't happen
		return

	if _should_play_sfx:
		_audio_player.stream = CANCEL_SFX.items.pick_random()
		_audio_player.play()

	inventory.drop_item(_last_cell.index)
	_hide_context_menu()


func _on_use_button_pressed() -> void:
	if _last_cell == null or _last_cell.index < 0:
		return

	inventory.use_item(_last_cell.index)
	_hide_context_menu()


func _on_close_button_pressed() -> void:
	if _should_play_sfx:
		_audio_player.stream = MENU_SELECT_SFX.items.pick_random()
		_audio_player.play()

	visible = false
	get_tree().paused = false


func _on_go_home_button_pressed() -> void:
	if _should_play_sfx:
		_audio_player.stream = MENU_SELECT_SFX.items.pick_random()
		_audio_player.play()

	visible = false
	get_tree().paused = false


func _on_unload_button_pressed() -> void:
	if _last_cell == null or _last_cell.index < 0:
		return

	if _should_play_sfx:
		_audio_player.stream = CANCEL_SFX.items.pick_random()
		_audio_player.play()

	inventory.remove_item(_last_cell.index)
	_hide_context_menu()


func _on_button_focus_entered() -> void:
	if _should_play_sfx:
		_audio_player.stream = MENU_NAVIGATION_SFX.items.pick_random()
		_audio_player.play()
