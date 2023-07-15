class_name KitchenMenu
extends ShopMenu

const ITEM_DOUGH = preload("res://items/ingredients/dough.tres")
const ICON_BAGEL = preload("res://items/icons/icon_bagel.tres")

@onready var _kitchen_inventory: InventoryComponent = $"KitchenInventoryComponent"
@onready var _storage_grid: InventoryGrid = $"ScrollContainer/MarginContainer/VBoxContainer/StorageInventoryGrid"
@onready var _kitchen_grid: InventoryGrid = $"ScrollContainer/MarginContainer/VBoxContainer/KitchenInventoryGrid"
@onready var _cook_button: BetterButton = $"ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/CookButton"

var _needs_dough = true
var _product: Product = Product.new()

func _ready() -> void:
	super._ready()
	# TODO: calculate and assign max items
	_kitchen_inventory.inventory = Inventory.new()
	_kitchen_inventory.changed.connect(_on_kitchen_inventory_changed)
	_kitchen_grid.inventory = _kitchen_inventory

	await owner.ready
	_storage_grid.inventory = owner.storage_inventory
	_storage_grid.item_filter = func(i): return i is Ingredient


func enter() -> void:
	super.enter()
	_storage_grid.call_deferred("focus_first_cell")
	_on_kitchen_inventory_changed(null)


func _on_kitchen_inventory_changed(_inventory: InventoryComponent) -> void:
	_needs_dough = true
	var traits = {}

	for i in _kitchen_inventory.items:
		if i == ITEM_DOUGH:
			_needs_dough = false
		for t in range(i.traits.size()):
			var item_trait = i.traits[t]
			traits[item_trait] = traits.get(item_trait, 0) + i.trait_strength[t]

	_product.clear_traits()
	for key in traits:
		if traits[key] > 0:
			var t = TraitStrength.new()
			t.item_trait = key
			t.strength = traits[key]
			_product.traits.append(t)

	_cook_button.disabled = _needs_dough


func _on_inventory_grid_cell_highlighted(cell: InventoryCell) -> void:
	if cell.is_empty():
		message_shown.emit("")
		return
	var text = "%s\n%s" % [cell.item.get_item_name().capitalize(),
		cell.item.get_item_description()]
	message_shown.emit(text)


func _on_storage_inventory_grid_cell_selected(cell) -> void:
	cell.button_pressed = false
	if not _kitchen_inventory.has_space():
		return
	_kitchen_inventory.add_item(cell.item)
	owner.storage_inventory.remove_item(cell.index)


func _on_kitchen_inventory_grid_cell_selected(cell) -> void:
	cell.button_pressed = false
	owner.storage_inventory.add_item(cell.item)
	_kitchen_inventory.remove_item(cell.index)


func _on_back_button_pressed() -> void:
	owner.storage_inventory.add_items(_kitchen_inventory.items)
	_kitchen_inventory.clear()
	super._on_back_button_pressed()


func _on_cook_button_pressed() -> void:
	_product.icon = ICON_BAGEL
	owner.storage_inventory.add_item(_product)
	_kitchen_inventory.clear()
	_product = Product.new()


func _on_cook_button_focus_entered() -> void:
	if _needs_dough:
		message_shown.emit(tr("ui_needs_dough"))
	else:
		message_shown.emit(_product.get_item_description())
