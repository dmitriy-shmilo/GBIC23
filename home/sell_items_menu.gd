class_name SellItemsMenu
extends MarketBuyMenu


func _ready() -> void:
	await owner.ready
	market_inventory = owner.market_inventory
	storage_inventory = owner.storage_inventory
	super._ready()
