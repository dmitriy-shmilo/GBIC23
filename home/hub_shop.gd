class_name HubShop
extends Control

signal back_pressed()

@export var first_button: Button = null

func enter() -> void:
	visible = true
	if first_button != null:
		first_button.grab_focus()


func exit() -> void:
	visible = false
