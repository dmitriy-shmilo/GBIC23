class_name Pickup
extends CharacterBody2D

const FRICTION = 32.0
const pickup_sfx = preload("res://assets/sfx/pickup.tres")

@export var item: Item: set = _set_item
@export var is_highlighted = false: set = _set_is_highlighted

@onready var _body_sprite: Sprite2D = $"BodySprite"
@onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
@onready var _audio_player: AudioStreamPlayer2D = $"AudioPlayer"
@onready var _hint_label: Label = $"Hint"

var is_picked_up = false

func _ready() -> void:
	_set_item(item)
	_set_is_highlighted(is_highlighted)
	var key: InputEvent = InputMap.action_get_events("interact")[0]
	_hint_label.text = tr("ui_pickup_hint") % key.as_text()


func push(force: Vector2) -> void:
	velocity += force


func loot() -> void:
	if is_picked_up:
		return
	is_picked_up = true

	_audio_player.stream = pickup_sfx.items.pick_random()
	_audio_player.play()
	_animation_player.play("loot")


func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _set_item(i: Item) -> void:
	item = i
	if is_inside_tree() and i != null:
		_body_sprite.texture = i.icon


func _set_is_highlighted(value) -> void:
	if is_picked_up:
		return
	is_highlighted = value
	if is_inside_tree():
		_animation_player.play("highlight" if value else "RESET")
