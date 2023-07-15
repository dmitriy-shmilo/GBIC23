class_name PortalShop
extends HubShop

@export var storage_inventory: InventoryComponent = null
@export var pockets_inventory: InventoryComponent = null

@onready var _embark_menu: PortalEmbarkMenu = $"EmbarkMenu"
@onready var _exit_button: BetterButton = $"BuyPortalMenu/MarginContainer/BuyPortalMenu/BuyPortalBackButton"
@onready var _portal_buy_button1: BetterButton = $"BuyPortalMenu/MarginContainer/BuyPortalMenu/BuyPortal1/PortalBuyButton"
@onready var _portal_buy_button2: BetterButton = $"BuyPortalMenu/MarginContainer/BuyPortalMenu/BuyPortal2/PortalBuyButton"
@onready var _portal_buy_button3: BetterButton = $"BuyPortalMenu/MarginContainer/BuyPortalMenu/BuyPortal3/PortalBuyButton"
@onready var _portal_buy_button4: BetterButton = $"BuyPortalMenu/MarginContainer/BuyPortalMenu/BuyPortal4/PortalBuyButton"
@onready var _text_label = $"TextPanel/TextLabel"

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

var _last_gossip = 0
var _gossip = [
	"gossip_portal_1",
	"gossip_portal_2",
	"gossip_portal_3",
	"gossip_portal_4",
	"gossip_portal_5",
]

func _ready() -> void:
	super._ready()
	for b in _portal_buy_buttons:
		b.pressed.connect(_on_portal_buy_button_pressed.bind(b))
	_exit_button.focus_entered.connect(_on_shop_button_focused.bind(_exit_button))


func enter() -> void:
	super.enter()
	for b in _portal_buy_buttons:
		b.disabled = SaveManager.data.money < _portal_costs[b.tag] and b.tag != 0


func _on_portal_buy_button_pressed(button: BetterButton) -> void:
	if storage_inventory.items.any(func(i): return i is Consumable):
		_embark_menu.cost = _portal_costs[button.tag]
		push_menu(_embark_menu)
		return

	var cost = _portal_costs[button.tag]
	SaveManager.data.money -= cost
	get_tree().change_scene_to_file("res://main.tscn")


func _on_portal_gossip_button_pressed() -> void:
	var text = tr(_gossip[_last_gossip])
	_text_label.text = text
	_last_gossip = (_last_gossip + 1) % _gossip.size()
