class_name GuiAudioAutoload
extends Node

const CANCEL_SFX = preload("res://assets/sfx/cancel.tres")
const MENU_NAVIGATION_SFX = preload("res://assets/sfx/menu_navigation.tres")
const MENU_SELECT_SFX = preload("res://assets/sfx/menu_select.tres")

@onready var _player: AudioStreamPlayer = $"AudioStreamPlayer"

func play_cancel() -> void:
	CANCEL_SFX.play_random(_player)


func play_navigation() -> void:
	MENU_NAVIGATION_SFX.play_random(_player)


func play_select() -> void:
	MENU_SELECT_SFX.play_random(_player)
