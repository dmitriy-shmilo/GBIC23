class_name Enemy
extends CharacterBody2D

const impact_sfx: SfxCollection = preload("res://assets/sfx/impact.tres")
const heal_sfx: SfxCollection = preload("res://assets/sfx/heal.tres")

@onready var _sprite: AnimatedSprite2D = $"BodySprite"
@onready var _hit_box: Area2D = $"HitBox"
@onready var _movement_machine: StateMachine = $"MovementMachine"
@onready var _audio_player: AudioStreamPlayer2D = $"AudioPlayer"

var _direction_suffix = "down"
var _animation_root = "idle"


func _play_animation() -> void:
	_sprite.play(_animation_root + "_" + _direction_suffix)


func _on_attack_machine_transitioned(state_name) -> void:
	match state_name:
		"Attack":
			_animation_root = "attack"
		"Ready":
			match _movement_machine.current_state.name:
				"Idle":
					_animation_root = "idle"
				"Chase", "Wonder":
					_animation_root = "move"
	_play_animation()


func _on_movement_machine_transitioned(state_name) -> void:
	match state_name:
		"Idle":
			_animation_root = "idle"
		"Chase", "Wonder":
			_animation_root = "move"

	_play_animation()


func _on_move_direction_changed(direction) -> void:
	var is_vertical = abs(direction.y) > abs(direction.x)
	if !is_vertical and direction.x >= 0:
		_direction_suffix = "right"
		_hit_box.rotation_degrees = -90
	elif !is_vertical and direction.x < 0:
		_direction_suffix = "left"
		_hit_box.rotation_degrees = 90
	elif is_vertical and direction.y >= 0:
		_direction_suffix = "down"
		_hit_box.rotation_degrees = 0
	elif is_vertical and direction.y < 0:
		_direction_suffix = "up"
		_hit_box.rotation_degrees = 180

	_play_animation()


func _on_vitals_component_health_changed(vitals: VitalsComponent, positive: bool) -> void:
	if positive:
		_audio_player.stream = heal_sfx.items.pick_random()
	else:
		_audio_player.stream = impact_sfx.items.pick_random()
	_audio_player.play()

	# TODO: death state
	if vitals.current_health <= 0:
		queue_free()
