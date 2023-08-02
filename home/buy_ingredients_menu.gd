class_name BuyIngredientsMenu
extends MarketBuyMenu

func _ready() -> void:
	await owner.ready
	market_inventory = owner.market_inventory
	storage_inventory = owner.storage_inventory
	item_filter = func(i): return i is Ingredient
	super._ready()


