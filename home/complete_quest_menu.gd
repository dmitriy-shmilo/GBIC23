class_name CompleteQuestMenu
extends ShopMenu

@export var quest: Quest = null
@onready var _storage_grid: InventoryGrid = $"ScrollContainer/MarginContainer/VBoxContainer/StorageInventoryGrid"
@onready var _counter_grid: InventoryGrid = $"ScrollContainer/MarginContainer/VBoxContainer/CounterInventoryGrid"

func _ready() -> void:
	super._ready()
	await owner.ready
	_counter_grid.inventory = owner.counter_inventory
	_storage_grid.inventory = owner.storage_inventory


func enter() -> void:
	super.enter()
	_storage_grid.item_filter = func(i): return quest != null and i is Product and quest.is_match(i)
	_counter_grid.item_filter = func(i): return quest != null and i is Product and quest.is_match(i)
	_storage_grid.call_deferred("focus_first_cell")


func _complete_quest() -> void:
	SaveManager.data.remove_quest(quest)
	SaveManager.data.money += quest.get_reward()


func _on_storage_inventory_grid_cell_selected(cell: InventoryCell) -> void:
	cell.button_pressed = false
	_complete_quest()
	owner.storage_inventory.remove_item(cell.index)
	owner.pop_menu()


func _on_counter_inventory_grid_cell_selected(cell: InventoryCell) -> void:
	cell.button_pressed = false
	_complete_quest()
	owner.counter_inventory.remove_item(cell.index)
	owner.pop_menu()


func _on_inventory_grid_cell_highlighted(cell: InventoryCell) -> void:
	if cell.is_empty():
		message_shown.emit("")
		return
	var text = "%s\n%s" % [cell.item.get_item_name().capitalize(),
		cell.item.get_item_description()]
	message_shown.emit(text)
