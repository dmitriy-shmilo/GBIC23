class_name ShopMenu
extends PanelContainer

@export var initial_button: Button = null
@export var back_button: Button = null

func _ready() -> void:
	if back_button != null:
		back_button.pressed.connect(_on_back_button_pressed)


func enter() -> void:
	visible = true
	if initial_button != null:
		initial_button.grab_focus()


func exit() -> void:
	visible = false


func _on_back_button_pressed() -> void:
	if owner is HubShop:
		owner.pop_menu()
