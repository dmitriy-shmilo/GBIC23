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

## A list of all purchased upgrades across all shops.
@export var upgrades: Array[ShopUpgrade] = []

## All available quests.
@export var available_quests: Array[Quest] = []

## A subset of available_quests.
@export var accepted_quests: Array[Quest] = []

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


func refresh_quests() -> void:
	# TODO: base on upgrades
	var total_quests = 5

	for i in range(available_quests.size(), 0, -1):
		var quest = available_quests[i - 1]
		if quest.expiration_day <= date:
			available_quests[i] = null
			var accepted_index = accepted_quests.find(quest)
			if accepted_index >= 0:
				accepted_quests.remove_at(accepted_index)

	var available_count = available_quests.size()
	var new_quests = randi_range(0 if available_count > 0 else 1, total_quests - available_count)


	for i in range(available_quests.size(), new_quests):
		var quest = Quest.generate(5 + randi() % 5,
			i < 2 and accepted_quests.size() > 0,
			min(14, accepted_quests.size() * 2 + 3),
			null)
		available_quests.push_back(quest)
