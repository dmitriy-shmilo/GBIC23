class_name SaveData
extends Resource

signal money_changed(old, new)

## Current player cash, can be negative
@export var money = 0: set = set_money

## Permanent player storage. Persisted between runs.
@export var storage_inventory = Inventory.new()

## Permanent bagels for sale storage.
@export var counter_inventory = Inventory.new()

## Temporary storage filled when interacting with a portal.
## Eventually transfers itc contents to storage_inventory.
@export var portal_inventory = Inventory.new()

## Temporary player inventory. Can transfer items to
## portal_inventory when interacting with the portal.
## Transfers all items to storage_inventory upon return to the hub.
@export var pockets_inventory = Inventory.new()

## Hub market inventory. Is cleared and restocked every time the player
## returns to town.
@export var market_inventory = Inventory.new()

func set_money(value: int) -> void:
	var old = money
	money = value
	money_changed.emit(old, money)
