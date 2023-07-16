class_name Pickup
extends CharacterBody2D

const FRICTION = 32.0
const PICKUP_SFX = preload("res://assets/sfx/pickup.tres")

@export var item: Item: set = _set_item

@onready var _body_sprite: Sprite2D = $"BodySprite"
@onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
@onready var _audio_player: AudioStreamPlayer2D = $"AudioPlayer"
@onready var _hint_label: Label = $"Hint"

var is_picked_up = false

func _ready() -> void:
	_set_item(item)
	var key: InputEvent = InputMap.action_get_events("interact")[0]
	_hint_label.text = "%s [%s]" % [tr("ui_pickup_hint"), key.as_text()]


func push(force: Vector2) -> void:
	velocity += force


func _physics_process(delta: float) -> void:
	if velocity == Vector2.ZERO:
		return

	move_and_slide()
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _set_item(i: Item) -> void:
	item = i
	if is_inside_tree() and i != null:
		_body_sprite.texture = i.icon


func _on_interactive_component_target_changed(_interactor, targets) -> void:
	if is_picked_up:
		return
	_animation_player.play("highlight" if targets else "RESET")


func _on_interactive_component_interacted(_interactor) -> void:
	if is_picked_up:
		return
	is_picked_up = true

	PICKUP_SFX.play_random_2d(_audio_player)
	_animation_player.play("loot")
