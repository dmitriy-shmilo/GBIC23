class_name PauseGui
extends Control

const INVENTORY_CELL_SCENE = preload("res://gui/inventory_cell.tscn")

@export var inventory: InventoryComponent = null

@onready var _inventory_grid: GridContainer = $"%InventoryGrid"

func _ready() -> void:
	visible = false
	inventory.connect("changed", _on_inventory_changed)
	_on_inventory_changed(inventory)


func enter() -> void:
	visible = true
	get_tree().paused = true
	_inventory_grid.get_child(0).call_deferred("grab_focus")


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

	for i in range(inventory.items.size()):
		var item = inventory.items[i]
		var cell = _inventory_grid.get_child(i)
		cell.item = item
