class_name SaveData
extends Resource

signal money_changed(old, new)

## Current player cash, can be negative
@export var money = 0: set = set_money

## Permanent player storage. Persisted between runs.
@export var player_storage = Inventory.new()

## Temporary storage filled when interacting with a portal.
## Eventually transfers itc contents to player_storage.
@export var portal_storage = Inventory.new()

## Temporary player inventory. Can transfer items to
## portal_storage when interacting with the portal.
## Transfers all items to player_storage upon return to the hub.
@export var player_pockets = Inventory.new()

func set_money(value: int) -> void:
	var old = money
	money = value
	money_changed.emit(old, money)
