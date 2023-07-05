class_name Chest
extends Node2D

const chest_texture = preload("res://map/chest_normal.tres")
const rare_chest_texture = preload("res://map/chest_rare.tres")
const pickup_sfx = preload("res://assets/sfx/pickup.tres")

@export var is_rare = false: set = _set_is_rare
@export var is_highlighted = false: set = _set_is_highlighted

@onready var _body_sprite: Sprite2D = $"BodySprite"
@onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
@onready var _audio_player: AudioStreamPlayer2D = $"AudioPlayer"

func _ready() -> void:
	_set_is_rare(is_rare)
	_set_is_highlighted(is_highlighted)


func loot() -> void:
	_animation_player.play("loot")
	_audio_player.stream = pickup_sfx.items.pick_random()
	_audio_player.play()
	await _audio_player.finished
	await _animation_player.animation_finished
	queue_free()


func _set_is_rare(rare) -> void:
	is_rare = rare
	if is_inside_tree():
		_body_sprite.texture = rare_chest_texture if rare else chest_texture


func _set_is_highlighted(value) -> void:
	is_highlighted = value
	if is_inside_tree():
		# TODO: outline shader
		_body_sprite.modulate = Color.GREEN if value else Color.WHITE
