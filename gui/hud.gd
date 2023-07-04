class_name Hud
extends Control

@export var vitals: VitalsComponent = null

@onready var _health_container: HBoxContainer = $"%HealthContainer"
@onready var _extra_health_label = $"%HealthContainer/ExtraHealthLabel"
@onready var _health_icon_template = $"%HealthIconTemplate"

const MAX_ICONS = 3
func _ready() -> void:
	vitals.connect("health_changed", _on_vitals_health_changed)
	for i in range(MAX_ICONS):
		var heart_rect = _health_icon_template.duplicate(0)
		heart_rect.visible = true
		_health_container.add_child(heart_rect)
	_extra_health_label.move_to_front()
	_refresh_health(vitals)

func _refresh_health(new_vitals: VitalsComponent) -> void:
	var extra_health = new_vitals.current_health - MAX_ICONS
	if extra_health > 0:
		_extra_health_label.text = "+%d" % [extra_health]
	else:
		_extra_health_label.text = " "

	for i in range(MAX_ICONS):
		var icon = _health_container.get_child(i + 1)
		icon.visible = i < new_vitals.current_health


func _on_vitals_health_changed(new_vitals) -> void:
	_refresh_health(new_vitals)