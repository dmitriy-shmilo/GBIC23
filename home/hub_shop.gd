class_name HubShop
extends Control

signal back_pressed()

@export var initial_menu: ShopMenu = null
@export var hint_label: RichTextLabel = null

var _menu_stack: Array[ShopMenu] = []

func _ready() -> void:
	for menu in get_children():
		if menu is ShopMenu:
			menu.button_focused.connect(_on_shop_button_focused)
			menu.message_shown.connect(_on_shop_message_shown)


func enter() -> void:
	visible = true
	for menu in get_children():
		if menu is ShopMenu:
			menu.visible = false

	if initial_menu != null:
		push_menu(initial_menu)


func exit() -> void:
	visible = false


func push_menu(menu: Control) -> void:
	if _menu_stack.size() > 0:
		_menu_stack[_menu_stack.size() - 1].exit()
	_menu_stack.push_back(menu)
	menu.enter()


func pop_menu() -> void:
	if _menu_stack.size() > 0:
		var menu = _menu_stack.pop_back()
		menu.exit()

		if _menu_stack.size() > 0:
			(_menu_stack[_menu_stack.size() - 1] as ShopMenu).enter()
		else:
			back_pressed.emit()
	else:
		back_pressed.emit()


func _on_shop_button_focused(button: BetterButton) -> void:
	if button.loc_hint != "" and hint_label != null:
		hint_label.text = tr(button.loc_hint)


func _on_shop_message_shown(message: String) -> void:
	if hint_label != null:
		hint_label.text = message
