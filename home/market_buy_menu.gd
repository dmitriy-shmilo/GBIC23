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



func get_purchase_price(item: Item) -> int:
	if item is Consumable:
		return item.strength * 10

	if item is Ingredient:
		var trait_count = item.traits.size()
		var trait_total = item.trait_strength.reduce(func (a, b): return a + b, 0)
		return max(trait_count, 2) * max(4, trait_total) / 2

	return 0


func get_selling_price(item: Item) -> int:
	if item is Consumable:
		return item.strength * 2

	if item is Ingredient:
		var trait_count = item.traits.size()
		var trait_total = item.trait_strength.reduce(func (a, b): return a + b, 0)
		return max(1, max(trait_count, 1) * max(1, trait_total) / 3)

	return 0


func _on_market_cell_selected(cell: InventoryCell) -> void:
	market_inventory.remove_item(cell.index)
	storage_inventory.add_item(cell.item)
	return


func _on_storage_cell_selected(cell: InventoryCell) -> void:
	storage_inventory.remove_item(cell.index)
	market_inventory.add_item(cell.item)
	return
