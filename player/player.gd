class_name Player
extends CharacterBody2D

signal portal_invoked()

const ITEM_DROP_RANGE = 48.0
# TODO: consider playing sounds within the state
const impact_sfx: SfxCollection = preload("res://assets/sfx/impact.tres")
const heal_sfx: SfxCollection = preload("res://assets/sfx/heal.tres")
const swoosh_sfx: SfxCollection = preload("res://assets/sfx/swoosh.tres")
const PICKUP_SCENE := preload("res://map/pickup.tscn")

@onready var _sprite: AnimatedSprite2D = $"BodySprite"
@onready var _hit_box: Area2D = $"HitBox"
@onready var _movement_machine: StateMachine = $"MovementMachine"
@onready var _audio_player: AudioStreamPlayer = $"AudioPlayer"
@onready var _vitals: VitalsComponent = $"VitalsComponent"

var _direction_suffix = "down"
var _animation_root = "idle"


func _play_animation() -> void:
	_sprite.play(_animation_root + "_" + _direction_suffix)


func _on_attack_machine_transitioned(state_name) -> void:
	match state_name:
		"Portal":
			portal_invoked.emit()
		"Attack":
			_audio_player.stream = swoosh_sfx.items.pick_random()
			_audio_player.play()
			_animation_root = "attack"
		"Ready":
			match _movement_machine.current_state.name:
				"Idle", "KnockBack":
					_animation_root = "idle"
				"Move":
					_animation_root = "move"
	_play_animation()


func _on_state_machine_transitioned(state_name) -> void:
	match state_name:
		"Idle", "KnockBack":
			_animation_root = "idle"
		"Move":
			_animation_root = "move"

	_play_animation()


func _on_move_direction_changed(direction) -> void:
	if direction.x > 0:
		_direction_suffix = "right"
		_hit_box.rotation_degrees = -90
	elif direction.x < 0:
		_direction_suffix = "left"
		_hit_box.rotation_degrees = 90
	elif direction.y > 0:
		_direction_suffix = "down"
		_hit_box.rotation_degrees = 0
	elif direction.y < 0:
		_direction_suffix = "up"
		_hit_box.rotation_degrees = 180

	_play_animation()


func _on_vitals_component_health_changed(vitals: VitalsComponent, positive: bool) -> void:
	if positive:
		_audio_player.stream = heal_sfx.items.pick_random()
	else:
		_audio_player.stream = impact_sfx.items.pick_random()
	_audio_player.play()

	if vitals.current_health <= 0:
		# TODO: exit the level
		visible = false


func _on_inventory_component_item_dropped(_inventory: InventoryComponent, item: Item) -> void:
	var pickup = PICKUP_SCENE.instantiate() as Pickup
	pickup.item = item
	var offset = Vector2(randf() * ITEM_DROP_RANGE - ITEM_DROP_RANGE / 2.0, randf() * ITEM_DROP_RANGE - ITEM_DROP_RANGE / 2.0)
	pickup.global_position = global_position + offset
	pickup.push(offset)
	add_sibling(pickup)


func _on_inventory_component_item_used(_inventory: InventoryComponent, item: Consumable) -> void:
	_vitals.apply_consumable(item)

