class_name Pickup
extends Node2D

const pickup_sfx = preload("res://assets/sfx/pickup.tres")

@export var item: Item: set = _set_item
@export var is_highlighted = false: set = _set_is_highlighted

@onready var _body_sprite: Sprite2D = $"BodySprite"
@onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
@onready var _audio_player: AudioStreamPlayer2D = $"AudioPlayer"
@onready var _hint_label: Label = $"Hint"

func _ready() -> void:
	_set_item(item)
	_set_is_highlighted(is_highlighted)


func loot() -> void:
	_animation_player.play("loot")
	_audio_player.stream = pickup_sfx.items.pick_random()
	_audio_player.play()
	await _audio_player.finished
	await _animation_player.animation_finished
	queue_free()


func _set_item(i: Item) -> void:
	item = i
	if is_inside_tree():
		_body_sprite.texture = i.icon


func _set_is_highlighted(value) -> void:
	is_highlighted = value
	if is_inside_tree():
		_animation_player.play("highlight" if value else "RESET")
