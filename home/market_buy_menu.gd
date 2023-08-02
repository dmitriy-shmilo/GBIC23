class_name MarketBuyMenu
extends ShopMenu

@export var market_grid: InventoryGrid = null
@export var storage_grid: InventoryGrid = null
@export var market_inventory: InventoryComponent = null
@export var storage_inventory: InventoryComponent = null
var item_filter: Callable

func _ready() -> void:
	super._ready()
	market_grid.inventory = market_inventory
	market_grid.item_filter = item_filter
	market_grid.cell_selected.connect(_on_market_cell_selected)
	storage_grid.inventory = storage_inventory
	storage_grid.item_filter = item_filter
	storage_grid.cell_selected.connect(_on_storage_cell_selected)


func _on_market_cell_selected(cell: InventoryCell) -> void:
	cell.button_pressed = false
	var price = cell.item.get_purchase_price()
	if SaveManager.data.money >= price:
		SaveManager.data.money -= price
		market_inventory.remove_item(cell.index)
		storage_inventory.add_item(cell.item)



func _on_storage_cell_selected(cell: InventoryCell) -> void:
	cell.button_pressed = false
	var price = cell.item.get_selling_price()
	SaveManager.data.money += price
	storage_inventory.remove_item(cell.index)
	market_inventory.add_item(cell.item)
	return
