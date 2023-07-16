class_name SalesSummaryMenu
extends ShopMenu

@onready var _sales_inventory: InventoryComponent = $"SalesInventoryComponent"
@onready var _sales_grid: InventoryGrid = $"ScrollContainer/MarginContainer/VBoxContainer/SalesInventoryGrid"
@onready var _sales_label: Label = $"ScrollContainer/MarginContainer/VBoxContainer/SalesLabel"

var _counter_inventory: InventoryComponent = null
var _profit = 0

func _ready() -> void:
	super._ready()
	await owner.ready
	_counter_inventory = owner.counter_inventory


func enter() -> void:
	super.enter()
	_profit = 0
	# TODO: sell items randomly
	_sales_inventory.set_block_signals(true)
	_sales_inventory.clear()
	for product in _counter_inventory.items:
		if product is Product:
			_sales_inventory.add_item(product)
			_profit += product.get_selling_price()
	_sales_inventory.set_block_signals(false)
	_sales_inventory.changed.emit(_sales_inventory)
	_counter_inventory.clear()

	_sales_label.text = tr("ui_summary_counter") % _profit
	_sales_grid.focus_first_cell()

	SaveManager.data.money += _profit
	SaveManager.data.date += 1


func _on_sales_inventory_grid_cell_highlighted(cell) -> void:
	var product = cell.item as Product
	if product == null:
		message_shown.emit("")
		return
	var product_name = tr("hint_sold_product") % [product.get_item_name().capitalize(), product.get_selling_price()]
	var text = "%s\n%s" % [product_name, product.get_item_description()]
	message_shown.emit(text)
