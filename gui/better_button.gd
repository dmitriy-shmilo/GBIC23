class_name BetterButton
extends Button

@export var play_sfx = true
@export var tag = -1
@export var loc_hint = ""

var _focus_style: StyleBox = null
var _temp_focus_style: StyleBox = StyleBoxEmpty.new()

func _ready() -> void:
	_focus_style = get_theme_stylebox("focus")
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	focus_entered.connect(_on_focus_entered)
	mouse_entered.connect(_on_mouse_entered)
	pressed.connect(_on_pressed)


func _on_button_down() -> void:
	add_theme_stylebox_override("focus", _temp_focus_style)


func _on_button_up() -> void:
	add_theme_stylebox_override("focus", _focus_style)


func _on_focus_entered() -> void:
	GuiAudio.play_navigation()


func _on_mouse_entered() -> void:
	focus_entered.emit()

func _on_pressed() -> void:
	GuiAudio.play_select()
