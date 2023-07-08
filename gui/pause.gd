class_name PauseGui
extends Control

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
@onready var _context_cancel_button: Button = $"%ContextCancelButton"

var _should_play_sfx = false
var _last_cell: InventoryCell = null

func _ready() -> void:
	visible = false
	inventory.connect("changed", _on_inventory_changed)
	_on_inventory_changed(inventory)
	_context_menu.visible = false


func enter() -> void:
	visible = true
	get_tree().paused = true
	_inventory_grid.get_child(0).call_deferred("grab_focus")
	set_deferred("_should_play_sfx", true)


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
	_drop_button.grab_focus()



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		visible = false
		get_tree().paused = false
		get_viewport().set_input_as_handled()


func _on_inventory_changed(inventory: InventoryComponent) -> void:
	var existing_count = _inventory_grid.get_child_count()
	if existing_count < inventory.max_items:
		for i in range(inventory.max_items - existing_count):
			var cell = INVENTORY_CELL_SCENE.instantiate() as InventoryCell
			_inventory_grid.add_child(cell)
			cell.connect("focus_entered", _on_inventory_button_focus_entered)
			cell.connect("pressed", _on_inventory_button_pressed.bind(cell))

	for i in range(inventory.items.size()):
		var item = inventory.items[i]
		var cell = _inventory_grid.get_child(i)
		cell.item = item


func _on_inventory_button_focus_entered() -> void:
	if _should_play_sfx:
		_audio_player.stream = MENU_NAVIGATION_SFX.items.pick_random()
		_audio_player.play()


func _on_inventory_button_pressed(cell: InventoryCell) -> void:
	if cell.item == null:
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
	_context_menu.visible = false
	if _last_cell != null:
		_should_play_sfx = false
		_last_cell.grab_focus()
		_last_cell.button_pressed = false
		_should_play_sfx = true
