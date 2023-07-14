class_name StateVitalsDying
extends State

const BLINK_SHADER: ShaderMaterial = preload("res://base/shader/blink.tres")

@export var sprite: Node2D = null
@export var hurt_box: Area2D = null
@export var dying_time = 0.5

var _current_time = 0.0
var _shader: ShaderMaterial = null

func _ready() -> void:
	_shader = BLINK_SHADER.duplicate()
	_shader.set_shader_parameter("blink_color", Color(0.5, 0.5, 1.0, 0.25))
	_shader.set_shader_parameter("blink_frequency", 30.0)


func enter(_args = {}) -> void:
	_current_time = 0
	sprite.material = _shader
	for shape in hurt_box.get_children():
		if shape is CollisionShape2D:
			shape.set_deferred("disabled", true)


func exit() -> void:
	sprite.material = null
	for shape in hurt_box.get_children():
		if shape is CollisionShape2D:
			shape.set_deferred("disabled", false)


func physics_process(delta: float) -> void:
	_current_time += delta

	if _current_time >= dying_time:
		_current_time = 0.0
		state_machine.transition("Dead")

