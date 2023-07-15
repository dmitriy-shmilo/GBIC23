class_name ShopMenu
extends PanelContainer

signal button_focused(button)
signal message_shown(message)

@export var initial_button: Control = null
@export var back_button: Button = null

var _scroll_container: ScrollContainer = null

func _ready() -> void:
	_scroll_container = get_child(0) as ScrollContainer
	if back_button != null:
		back_button.pressed.connect(_on_back_button_pressed)
	var buttons = find_children("", "BetterButton", true)
	for b in buttons:
		b.focus_entered.connect(_on_button_focus_entered.bind(b))


func enter() -> void:
	visible = true
	if _scroll_container != null:
		_scroll_container.set_deferred("scroll_vertical", 0)
	if initial_button != null:
		initial_button.call_deferred("grab_focus")


func exit() -> void:
	visible = false


func _on_back_button_pressed() -> void:
	if owner is HubShop:
		owner.pop_menu()


func _on_button_focus_entered(button: BetterButton) -> void:
	button_focused.emit(button)
