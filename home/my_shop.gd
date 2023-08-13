class_name MyShop
extends HubShop

const CANNERY_UPGRADE = preload("res://items/upgrades/cannery_1.tres")

@export var storage_inventory: InventoryComponent = null
@export var counter_inventory: InventoryComponent = null

@onready var _packing_table_button: Button = $MainMenu/MarginContainer/Menu/PackingTableButton


func enter() -> void:
	super.enter()
	_packing_table_button.disabled = not SaveManager.data.upgrades.has(CANNERY_UPGRADE)
