class_name ShopMenu
extends PanelContainer

signal button_focused(button)

@export var initial_button: Button = null
@export var back_button: Button = null

func _ready() -> void:
	if back_button != null:
		back_button.pressed.connect(_on_back_button_pressed)
	var buttons = find_children("", "BetterButton", true)
	for b in buttons:
		b.focus_entered.connect(_on_button_focus_entered.bind(b))


func enter() -> void:
	visible = true
	if initial_button != null:
		initial_button.grab_focus()


func exit() -> void:
	visible = false


func _on_back_button_pressed() -> void:
	if owner is HubShop:
		owner.pop_menu()


func _on_button_focus_entered(button: BetterButton) -> void:
	button_focused.emit(button)
