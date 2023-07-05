class_name Player
extends CharacterBody2D

const impact_sfx: SfxCollection = preload("res://assets/sfx/impact.tres")
const heal_sfx: SfxCollection = preload("res://assets/sfx/heal.tres")

@onready var _sprite: AnimatedSprite2D = $"BodySprite"
@onready var _hit_box: Area2D = $"HitBox"
@onready var _movement_machine: StateMachine = $"MovementMachine"
@onready var _audio_player: AudioStreamPlayer = $"AudioPlayer"

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
