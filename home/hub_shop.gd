class_name HubShop
extends Control

signal back_pressed()

@export var first_button: Button = null
@export var hint_label: RichTextLabel = null
@export var button_container: Control = null

func _ready() -> void:
	if button_container != null:
		for button in button_container.get_children():
			if button is BetterButton:
				button.focus_entered.connect(_on_button_focused.bind(button))


func enter() -> void:
	visible = true
	if first_button != null:
		first_button.grab_focus()


func exit() -> void:
	visible = false


func _on_button_focused(button: BetterButton) -> void:
	hint_label.text = tr(button.loc_hint)
