class_name SummaryMenu
extends Control

@export var is_failed = false
@export var is_returning = false

@onready var _loot_inventory: InventoryComponent = $"LootInventoryComponent"
@onready var _lost_inventory: InventoryComponent = $"LostInventoryComponent"
@onready var _sale_inventory: InventoryComponent = $"SaleInventoryComponent"
@onready var _pockets_inventory: InventoryComponent = $"PocketsInventoryComponent"
@onready var _portal_inventory: InventoryComponent = $"PortalInventoryComponent"
@onready var _storage_inventory: InventoryComponent = $"StorageInventoryComponent"
@onready var _counter_inventory: InventoryComponent = $"CounterInventoryComponent"

@onready var _title_label: Label = $"%Title"
@onready var _sales_header: HBoxContainer = $"%Container/SalesHeader"
@onready var _loot_header: HBoxContainer = $"%Container/LootHeader"
@onready var _lost_header: HBoxContainer = $"%Container/LostHeader"
@onready var _sales_text: RichTextLabel = $"%Container/SalesText"
@onready var _sales_grid: InventoryGrid = $"%Container/SalesGrid"
@onready var _loot_text: RichTextLabel = $"%Container/LootText"
@onready var _loot_grid: InventoryGrid = $"%Container/LootGrid"
@onready var _lost_text: RichTextLabel = $"%Container/LostText"
@onready var _lost_grid: InventoryGrid = $"%Container/LostGrid"
@onready var _continue_button: BetterButton = %"ContinueButton"
@onready var _item_name_label: Label = %"ItemNameLabel"
@onready var _item_description_label: RichTextLabel = %"ItemDescriptionLabel"

func _ready() -> void:
	_portal_inventory.inventory = SaveManager.data.portal_inventory
	_counter_inventory.inventory = SaveManager.data.counter_inventory
	_pockets_inventory.inventory = SaveManager.data.pockets_inventory
	_storage_inventory.inventory = SaveManager.data.storage_inventory
	visible = false


func enter() -> void:
	get_tree().paused = true
	visible = true
	if is_returning:
		_enter_return()
	_enter_focus()


func _enter_return() -> void:
	_sales_header.visible = false
	_sales_text.visible = false
	_sales_grid.visible = false
	_loot_header.visible = true

	_loot_inventory.set_block_signals(true)
	if not is_failed:
		# TODO: disable change signals
		for i in _portal_inventory.items:
			if i is ItemContainer:
				# TODO: define looted container item in the ItemContainer
				_loot_inventory.add_item(i)
				_loot_inventory.add_items(i.contents)
		for i in _pockets_inventory.items:
			if i is ItemContainer:
				# TODO: define looted container item in the ItemContainer
				_loot_inventory.add_item(i)
				_loot_inventory.add_items(i.contents)
		_title_label.text = tr("ui_summary_return")
	else:
		# TODO: retain some items when upgraded
		_lost_inventory.add_items(_portal_inventory.items)
		_lost_inventory.add_items(_pockets_inventory.items)
		_title_label.text = tr("ui_summary_fail")
	_portal_inventory.clear()
	_pockets_inventory.clear()

	if _loot_inventory.is_empty():
		_loot_text.visible = true
		_loot_text.text = tr("ui_gained_loot_nothing")
		_loot_grid.visible = false
	else:
		_loot_text.visible = false
		_loot_grid.visible = true

	if _lost_inventory.is_empty():
		_lost_header.visible = false
		_lost_text.visible = false
		_lost_grid.visible = false
	else:
		_lost_header.visible = true
		_lost_text.visible = false
		_lost_grid.visible = true
	_loot_inventory.set_block_signals(false)
	_loot_inventory.changed.emit(_loot_inventory)


func _enter_focus() -> void:
	if _sales_grid.visible:
		_sales_grid.focus_first_cell()
	elif _loot_grid.visible:
		_loot_grid.focus_first_cell()
	elif _lost_grid.visible:
		_lost_grid.focus_first_cell()
	else:
		_continue_button.grab_focus()


func _on_continue_pressed() -> void:
	_storage_inventory.set_block_signals(true)
	for i in _loot_inventory.items:
		if i is Ingredient or i is Consumable:
			_storage_inventory.add_item(i)
	_storage_inventory.set_block_signals(false)
	_storage_inventory.changed.emit(_storage_inventory)

	get_tree().paused = false
	visible = false
	if is_returning:
		get_tree().change_scene_to_file("res://home/hub.tscn")


func _on_grid_cell_highlighted(cell) -> void:
	_item_name_label.text = tr(cell.item.loc_name).capitalize()
	if cell.item is Ingredient:
		_item_description_label.text = cell.item.get_rich_description()
	else:
		_item_description_label.text = tr(cell.item.loc_description)


func _on_continue_button_focus_entered() -> void:
	_item_name_label.text = ""
	_item_description_label.text = ""
