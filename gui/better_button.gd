class_name BetterButton
extends Button

var _focus_style: StyleBox = null
var _temp_focus_style: StyleBox = StyleBoxEmpty.new()

func _ready() -> void:
	_focus_style = get_theme_stylebox("focus")
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)


func _on_button_down() -> void:
	add_theme_stylebox_override("focus", _temp_focus_style)


func _on_button_up() -> void:
	add_theme_stylebox_override("focus", _focus_style)
