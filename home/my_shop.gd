class_name MyShop
extends HubShop

@export var storage_inventory: InventoryComponent = null: set = _set_storage_inventory
@export var counter_inventory: InventoryComponent = null: set = _set_counter_inventory

@onready var _storage_inventory_grid: InventoryGrid = %StorageInventoryGrid
@onready var _counter_inventory_grid: InventoryGrid = %CounterInventoryGrid


func enter() -> void:
	super.enter()
	_set_storage_inventory(storage_inventory)
	_set_counter_inventory(counter_inventory)


func _set_storage_inventory(i) -> void:
	storage_inventory = i
	if is_inside_tree():
		_storage_inventory_grid.inventory = storage_inventory


func _set_counter_inventory(i):
	counter_inventory = i
	if is_inside_tree():
		_counter_inventory_grid.inventory = counter_inventory
