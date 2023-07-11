class_name ShopButton
extends BetterButton

@export var submenu: Control = null


func _ready() -> void:
	super._ready()
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if submenu != null:
		(owner as HubShop).push_menu(submenu)
