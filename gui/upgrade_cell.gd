class_name UpgradeCell
extends Panel

const EMPTY = preload("res://items/upgrades/empty.tres")
const CHECKMARK = preload("res://home/icons/icon_checkmark.tres")
const COIN = preload("res://home/icons/icon_coin.tres")

signal highlighted()
signal selected()

@export var upgrade: ShopUpgrade = null: set = set_upgrade
@export var disabled = false: set = set_disabled
@export var purchased = false: set = set_purchased

@onready var _name_label: Label = $"NameLabel"
@onready var _icon_rect: TextureRect = $"IconRect"
@onready var _purchase_button: Button = $"PurchaseButton"

func _ready() -> void:
	set_upgrade(upgrade)


func set_upgrade(value: ShopUpgrade) -> void:
	upgrade = value
	if upgrade == null:
		upgrade = EMPTY
	if is_inside_tree():
		_name_label.text = tr(upgrade.loc_name)
		_purchase_button.text = "%d" % upgrade.base_price
		_icon_rect.texture = upgrade.icon


func set_disabled(value: bool) -> void:
	disabled = value
	if is_inside_tree():
		_purchase_button.disabled = disabled or purchased


func set_purchased(value: bool) -> void:
	purchased = value
	if is_inside_tree():
		_purchase_button.disabled = disabled or purchased
		_purchase_button.icon = CHECKMARK if purchased else COIN


func _on_purchase_button_focus_entered() -> void:
	highlighted.emit()


func _on_purchase_button_pressed() -> void:
	selected.emit()
