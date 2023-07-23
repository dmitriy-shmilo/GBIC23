class_name Hud
extends Control

const MAX_ICONS = 10

@export var vitals: VitalsComponent = null
@export var inventory: InventoryComponent = null
@export var portal: Portal = null
@export var player: Player = null

@onready var _food_progress_bar: ProgressBar = $"FoodContainer/ProgressBar"
@onready var _health_container: HBoxContainer = $"%HealthContainer"
@onready var _food_container:  HBoxContainer = $"FoodContainer"
@onready var _extra_health_label = $"%HealthContainer/ExtraHealthLabel"
@onready var _health_icon_template = $"%HealthIconTemplate"
@onready var _inventory_capacity_label = $"InventoryCapacityLabel"
@onready var _portal_indicator = $"PortalIndiciator"

var _screen_size = Vector2.ZERO
var _padded_size = Vector2.ZERO

func _ready() -> void:
	_screen_size = get_viewport_rect().size / 2
	_padded_size = Vector2(_screen_size.x - 16, _screen_size.y - 16)

	vitals.health_changed.connect(_on_vitals_health_changed)
	vitals.food_changed.connect(_on_vitals_food_changed)
	inventory.changed.connect(_on_inventory_changed)
	portal.screen_entered.connect(_on_portal_screen_entered)
	portal.screen_exited.connect(_on_portal_screen_exited)
	for i in range(MAX_ICONS):
		var heart_rect = _health_icon_template.duplicate(0)
		heart_rect.visible = true
		_health_container.add_child(heart_rect)
	_extra_health_label.move_to_front()
	_refresh_health(vitals)
	_refresh_food(vitals)
	_on_inventory_changed(inventory)


func _physics_process(_delta: float) -> void:
	var portal_pos = portal.global_position - player.global_position
	_portal_indicator.position = portal_pos.clamp(-_padded_size,
		_padded_size) + _screen_size


func _refresh_health(new_vitals: VitalsComponent) -> void:
	var extra_health = new_vitals.current_health - MAX_ICONS
	if extra_health > 0:
		_extra_health_label.text = "+%d" % [extra_health]
	else:
		_extra_health_label.text = " "

	for i in range(MAX_ICONS):
		var icon = _health_container.get_child(i + 1)
		icon.visible = i < new_vitals.current_health


func _refresh_food(new_vitals: VitalsComponent) -> void:
	_food_progress_bar.max_value = new_vitals.max_food
	_food_progress_bar.value = new_vitals.current_food

	var material = _food_container.material as ShaderMaterial

	if new_vitals.current_food < new_vitals.max_food / 8:
		material.set_shader_parameter("max_phase", 0.8)
		material.set_shader_parameter("blink_frequency", 16)
		material.set_shader_parameter("blink_color", Color.ORANGE_RED)
	elif new_vitals.current_food < new_vitals.max_food / 4:
		material.set_shader_parameter("max_phase", 0.6)
		material.set_shader_parameter("blink_frequency", 10)
		material.set_shader_parameter("blink_color", Color.DARK_ORANGE)
	elif new_vitals.current_food < new_vitals.max_food / 2:
		material.set_shader_parameter("max_phase", 0.4)
		material.set_shader_parameter("blink_frequency", 5)
		material.set_shader_parameter("blink_color", Color.YELLOW)
	else:
		material.set_shader_parameter("max_phase", 0.0)



func _on_vitals_health_changed(new_vitals: VitalsComponent, _positive: bool) -> void:
	_refresh_health(new_vitals)


func _on_vitals_food_changed(new_vitals: VitalsComponent, _positive: bool) -> void:
	_refresh_food(new_vitals)


func _on_inventory_changed(_inventory: InventoryComponent) -> void:
	_inventory_capacity_label.text = "%d/%d" % [inventory.items.size(), inventory.max_items]


func _on_portal_screen_entered() -> void:
	_portal_indicator.visible = false


func _on_portal_screen_exited() -> void:
	_portal_indicator.visible = true
