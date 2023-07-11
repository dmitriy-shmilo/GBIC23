class_name PortalShop
extends HubShop

@onready var _exit_button: BetterButton = $"BuyPortalMenu/MarginContainer/BuyPortalMenu/BuyPortalBackButton"
@onready var _portal_buy_button1: BetterButton = $"BuyPortalMenu/MarginContainer/BuyPortalMenu/BuyPortal1/PortalBuyButton"
@onready var _portal_buy_button2: BetterButton = $"BuyPortalMenu/MarginContainer/BuyPortalMenu/BuyPortal2/PortalBuyButton"
@onready var _portal_buy_button3: BetterButton = $"BuyPortalMenu/MarginContainer/BuyPortalMenu/BuyPortal3/PortalBuyButton"
@onready var _portal_buy_button4: BetterButton = $"BuyPortalMenu/MarginContainer/BuyPortalMenu/BuyPortal4/PortalBuyButton"

@onready var _portal_buy_buttons: Array[BetterButton] = [
	_portal_buy_button1,
	_portal_buy_button2,
	_portal_buy_button3,
	_portal_buy_button4,
]

var _portal_costs = [
	5,
	15,
	50,
	150
]


func _ready() -> void:
	super._ready()
	for b in _portal_buy_buttons:
		b.focus_entered.connect(_on_shop_button_focused.bind(b))
		b.pressed.connect(_on_portal_buy_button_pressed.bind(b))
	_exit_button.focus_entered.connect(_on_shop_button_focused.bind(_exit_button))


func _on_portal_buy_button_pressed(button: BetterButton) -> void:
	var cost = _portal_costs[button.tag]
	SaveManager.data.money -= cost
	get_tree().change_scene_to_file("res://main.tscn")
