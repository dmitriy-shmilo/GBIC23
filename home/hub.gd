class_name Hub
extends Control

@onready var _main_screen: Control = %"MainScreen"

# stats bar
@onready var _date_label: Label = %"DateLabel"
@onready var _money_label: Label = %"MoneyLabel"
@onready var _money_icon: TextureRect = %"MoneyIcon"
@onready var _storage_label: Label = %"StorageLabel"
@onready var _storage_icon: TextureRect = %"StorageIcon"

# inventories
@onready var _storage_inventory: InventoryComponent = %"StorageInventory"
@onready var _counter_inventory: InventoryComponent = %"CounterInventory"
@onready var _market_inventory: InventoryComponent = %"MarketInventory"
@onready var _pockets_inventory: InventoryComponent = %"PocketsInventory"

#shop buttons
@onready var _my_shop_button: Button = $"%MyShopButton"
@onready var _portal_shop_button: Button = $"%PortalShopButton"
@onready var _market_shop_button: Button = $"%MarketShopButton"
@onready var _carpenter_shop_button: Button = $"%CarpenterShopButton"
@onready var _barracks_shop_button: Button = $"%BarracksShopButton"
@onready var _credits_button: Button = %"CreditsButton"
@onready var _shop_buttons = [
	_my_shop_button,
	_portal_shop_button,
	_market_shop_button,
	_carpenter_shop_button,
	_barracks_shop_button,
	_credits_button
]

# shops
@onready var _my_shop: MyShop = %"MyShop"
@onready var _portal_shop: PortalShop = %"PortalShop"
@onready var _market_shop: MarketShop = %"MarketShop"
@onready var _carpenter_shop: CarpenterShop = %"CarpenterShop"
@onready var _barracks_shop: BarracksShop = %"BarracksShop"
@onready var _credits_shop: CreditsShop = %"CreditsShop"
@onready var _shops = [
	_my_shop,
	_portal_shop,
	_market_shop,
	_carpenter_shop,
	_barracks_shop,
	_credits_shop
]


func _ready() -> void:
	_storage_inventory.inventory = SaveManager.data.storage_inventory
	_counter_inventory.inventory = SaveManager.data.counter_inventory
	_market_inventory.inventory = SaveManager.data.market_inventory
	_pockets_inventory.inventory = SaveManager.data.pockets_inventory

	_main_screen.visible = true

	for i in range(_shops.size()):
		var shop = _shops[i]
		var shop_button = _shop_buttons[i]
		shop.back_pressed.connect(_on_shop_back_pressed.bind(shop_button, shop))
		shop.visible = false
		shop_button.pressed.connect(_on_shop_button_pressed.bind(shop))

	_my_shop_button.grab_focus()
	SaveManager.data.money_changed.connect(_on_save_data_money_changed)
	SaveManager.data.date_changed.connect(_on_save_data_date_changed)
	_on_save_data_money_changed(0, SaveManager.data.money)
	_on_save_data_date_changed(0, SaveManager.data.date)
	SaveManager.data.refresh_space()


func _on_shop_back_pressed(shop_button: Button, shop: HubShop) -> void:
	shop.exit()
	_main_screen.visible = true
	shop_button.grab_focus()


func _on_shop_button_pressed(shop: HubShop) -> void:
	_main_screen.visible = false
	shop.enter()


func _on_quit_button_pressed() -> void:
	SaveManager.save_data()
	get_tree().quit()


func _on_save_data_money_changed(_old: int, new: int) -> void:
	var max_money = SaveManager.data.max_money_space
	_money_label.text = "%d/%d" % [new, max_money]
	if new < 0 or new > max_money:
		(_money_icon.material as ShaderMaterial).set_shader_parameter("max_phase", 1.0)
	else:
		(_money_icon.material as ShaderMaterial).set_shader_parameter("max_phase", 0.0)


func _on_storage_inventory_changed(inventory) -> void:
	inventory.set_block_signals(true)
	var max_items = SaveManager.data.max_storage_space
	_storage_inventory.max_items = max_items
	_storage_label.text = "%d/%d" % [inventory.items.size(), max_items]
	if inventory.items.size() > max_items:
		(_storage_icon.material as ShaderMaterial).set_shader_parameter("max_phase", 1.0)
	else:
		(_storage_icon.material as ShaderMaterial).set_shader_parameter("max_phase", 0.0)
	inventory.set_block_signals(false)


func _on_save_data_date_changed(_old: int, _new: int) -> void:
	_date_label.text = SaveManager.data.get_formatted_current_date()


func _on_pockets_inventory_changed(inventory) -> void:
	inventory.set_block_signals(true)
	inventory.max_items = SaveManager.data.max_pockets_space
	inventory.set_block_signals(false)


func _on_counter_inventory_changed(inventory) -> void:
	inventory.set_block_signals(true)
	inventory.max_items = SaveManager.data.max_counter_space
	inventory.set_block_signals(false)
