class_name BuyConsumablesMenu
extends MarketBuyMenu


func _ready() -> void:
	await owner.ready
	market_inventory = owner.market_inventory
	storage_inventory = owner.storage_inventory
	item_filter = func(i): return i is Consumable
	super._ready()
