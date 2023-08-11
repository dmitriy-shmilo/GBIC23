class_name SaveData
extends Resource

const BASE_STORAGE_SPACE = 8
const BASE_MONEY_SPACE = 500

const MIN_MARKET_CONSUMABLES = 2
const MAX_MARKET_CONSUMABLES = 5
const MIN_MARKET_INGREDIENTS = 5
const MAX_MARKET_INGREDIENTS = 10

const MARKET_CONSUMABLES_TABLE = preload("res://items/tables/market_consumables.tres")
const MARKET_INGREDIENTS_TABLE = preload("res://items/tables/all_ingredients.tres")

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

@export var max_storage_space = BASE_STORAGE_SPACE
@export var max_money_space = BASE_MONEY_SPACE

func set_money(value: int) -> void:
	var old = money
	money = value
	money_changed.emit(old, money)


func set_date(value: int) -> void:
	var old = date
	date = value
	date_changed.emit(old, date)


func get_formatted_date() -> String:
	return tr("ui_date") % [date, tr(WEEKDAYS[date % WEEKDAYS.size()])]


func remove_quest(quest: Quest) -> void:
	var available_index = SaveManager.data.available_quests.find(quest)
	var accepted_index = SaveManager.data.accepted_quests.find(quest)

	if available_index >= 0:
		SaveManager.data.available_quests.remove_at(available_index)

	if accepted_index >= 0:
		SaveManager.data.accepted_quests.remove_at(accepted_index)


func refresh_quests() -> void:
	# TODO: base on upgrades
	var total_quests = 5

	for i in range(available_quests.size(), 0, -1):
		var quest = available_quests[i - 1]
		if quest == null or quest.expiration_day < date:
			var accepted_index = accepted_quests.find(quest)
			available_quests.remove_at(i - 1)
			if accepted_index >= 0:
				accepted_quests.remove_at(accepted_index)

	var available_count = available_quests.size()
	var new_quests = randi_range(0 if available_count > 0 else 1, total_quests - available_count)

	var offset = available_quests.size()
	for i in range(offset, new_quests):
		var index = offset + i
		var quest = Quest.generate(5 + randi() % 5,
			index > 2,
			min(14, (index + 1) * 2),
			null)
		available_quests.push_back(quest)


func refresh_market() -> void:
	market_inventory.begin_updates()
	market_inventory.clear()
	for i in range(randi_range(MIN_MARKET_CONSUMABLES, MAX_MARKET_CONSUMABLES)):
		var item = MARKET_CONSUMABLES_TABLE.pick_weighted()
		market_inventory.add_item(item)

	for i in range(randi_range(MIN_MARKET_INGREDIENTS, MAX_MARKET_INGREDIENTS)):
		var item = MARKET_INGREDIENTS_TABLE.pick_weighted()
		market_inventory.add_item(item)
	market_inventory.end_updates()


func refresh_space() -> void:
	# TODO: scan purchased upgrades and update max storage
	money_changed.emit(money, money)
	storage_inventory.changed.emit()
	return
