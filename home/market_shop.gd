class_name MarketShop
extends HubShop

@export var storage_inventory: InventoryComponent = null
@export var market_inventory: InventoryComponent = null

@onready var _storage_inventory_grid: InventoryGrid = %"StorageInventoryGrid"
@onready var _market_inventory_grid: InventoryGrid = %"MarketInventoryGrid"


func enter() -> void:
	super.enter()
	_storage_inventory_grid.inventory = storage_inventory
	_market_inventory_grid.inventory = market_inventory
