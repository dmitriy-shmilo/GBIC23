class_name Chest
extends Node2D

@export var is_rare = false: set = _set_is_rare
@export var is_highlighted = false: set = _set_is_highlighted

@onready var _body_sprite: Sprite2D = $"BodySprite"

const chest_texture = preload("res://map/chest_normal.tres")
const rare_chest_texture = preload("res://map/chest_rare.tres")

func _ready() -> void:
	_set_is_rare(is_rare)
	_set_is_highlighted(is_highlighted)


func _set_is_rare(rare) -> void:
	is_rare = rare
	if is_inside_tree():
		_body_sprite.texture = rare_chest_texture if rare else chest_texture


func _set_is_highlighted(value) -> void:
	is_highlighted = value
	if is_inside_tree():
		# TODO: outline shader
		_body_sprite.modulate = Color.GREEN if value else Color.WHITE
