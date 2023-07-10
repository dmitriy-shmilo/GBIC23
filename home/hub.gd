class_name Hub
extends Control

@onready var _main_screen: Control = $"%MainScreen"

#shop buttons
@onready var _my_shop_button: Button = $"%MyShopButton"
@onready var _portal_shop_button: Button = $"%PortalShopButton"
@onready var _market_shop_button: Button = $"%MarketShopButton"
@onready var _carpenter_shop_button: Button = $"%CarpenterShopButton"
@onready var _barracks_shop_button: Button = $"%BarracksShopButton"
@onready var _shop_buttons = [
	_my_shop_button,
	_portal_shop_button,
	_market_shop_button,
	_carpenter_shop_button,
	_barracks_shop_button
]

# shops
@onready var _portal_shop: PortalShop = $"%PortalShop"
@onready var _shops = [
	HubShop.new(),
	_portal_shop
]


func _ready() -> void:
	_main_screen.visible = true

	for i in range(_shops.size()):
		var shop = _shops[i]
		var shop_button = _shop_buttons[i]
		shop.back_pressed.connect(_on_shop_back_pressed.bind(shop_button, shop))
		shop.visible = false
		shop_button.pressed.connect(_on_shop_button_pressed.bind(shop))

	_my_shop_button.grab_focus()


func _on_shop_back_pressed(shop_button: Button, shop: HubShop) -> void:
	shop.exit()
	_main_screen.visible = true
	shop_button.grab_focus()


func _on_shop_button_pressed(shop: HubShop) -> void:
	_main_screen.visible = false
	shop.enter()


func _on_quit_button_pressed() -> void:
	# TODO: save
	get_tree().quit()
