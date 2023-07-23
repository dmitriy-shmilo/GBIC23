class_name Enemy
extends CharacterBody2D

signal died

@export var description: EnemyDescription = preload("res://enemy/descriptions/grunt_1.tres")

@onready var _sprite: AnimatedSprite2D = $"BodySprite"
@onready var _hit_box: Area2D = $"HitBox"
@onready var _movement_machine: StateMachine = $"MovementMachine"
@onready var _attack_machine: StateMachine = $"AttackMachine"
@onready var _vitals: VitalsComponent = $"VitalsComponent"
@onready var _movement: MovementComponent = $"MovementComponent"

var _direction_suffix = "down"
var _animation_root = "idle"


func _ready() -> void:
	_sprite.sprite_frames = description.frames
	_vitals.max_health = randi_range(description.min_health, description.max_health)
	_vitals.current_health = _vitals.max_health
	_movement.max_speed = randi_range(description.min_speed, description.max_speed)
	_movement.acceleration = clamp(_movement.max_speed * 6.0, 300.0, 600.0)


func _play_animation() -> void:
	_sprite.play(_animation_root + "_" + _direction_suffix)


func _on_vitals_machine_transitioned(state_name) -> void:
	match state_name:
		"Invulnerable":
			_attack_machine.transition("Interrupt")
		"Dying":
			died.emit()
			_attack_machine.set_physics_process(false)
			_movement_machine.set_physics_process(false)


func _on_attack_machine_transitioned(state_name) -> void:
	match state_name:
		"Attack":
			_animation_root = "attack"
		"Ready", "Cooldown", "Interrupt":
			match _movement_machine.current_state.name:
				"Idle":
					_animation_root = "idle"
				"Chase", "Wonder", "Return":
					_animation_root = "move"
	_play_animation()


func _on_movement_machine_transitioned(state_name) -> void:
	match state_name:
		"Idle":
			_animation_root = "idle"
		"Chase", "Wonder", "Return":
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
