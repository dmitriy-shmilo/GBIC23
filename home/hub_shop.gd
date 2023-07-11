class_name HubShop
extends Control

signal back_pressed()

@export var initial_menu: ShopMenu = null
@export var hint_label: RichTextLabel = null
@export var button_container: Control = null

var _menu_stack = []

func _ready() -> void:
	if button_container != null:
		for button in button_container.get_children():
			if button is BetterButton:
				button.focus_entered.connect(_on_shop_button_focused.bind(button))


func enter() -> void:
	visible = true
	if initial_menu != null:
		push_menu(initial_menu)


func exit() -> void:
	visible = false


func push_menu(menu: Control) -> void:
	if _menu_stack.size() > 1:
		(_menu_stack[_menu_stack.size() - 1] as Control).visible = false
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
	hint_label.text = tr(button.loc_hint)
