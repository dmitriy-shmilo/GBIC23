class_name ShopButton
extends BetterButton

@export var submenu: Control = null


func _on_pressed() -> void:
	super._on_pressed()
	if submenu != null:
		(owner as HubShop).push_menu(submenu)
