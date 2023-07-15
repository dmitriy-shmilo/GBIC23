class_name SaveData
extends Resource

const WEEKDAYS = [
	"ui_day_1",
	"ui_day_2",
	"ui_day_3",
	"ui_day_4",
	"ui_day_5",
	"ui_day_6",
	"ui_day_7"
]
signal money_changed(old, new)
signal date_changed(old, new)

## Current player cash, can be negative
@export var money = 0: set = set_money

## Current day number. Increases by one after every embark.
@export var date = 0: set = set_date

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


func set_date(value: int) -> void:
	var old = date
	date = value
	date_changed.emit(old, date)


func get_formatted_date() -> String:
	return tr("ui_date") % [date + 1, tr(WEEKDAYS[date % WEEKDAYS.size()])]
