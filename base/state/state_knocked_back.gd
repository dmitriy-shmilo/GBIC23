class_name StateKnockedBack
extends State

@export var hurt_box: Area2D = null
@export var body: CharacterBody2D = null
@export var movement: MovementComponent = null
@export var own_hit_box: Hazard = null

var _knockback_vector: Vector2 = Vector2.ZERO

func _ready() -> void:
	hurt_box.connect("area_entered", _on_hurt_box_area_entered)


func physics_process(delta: float) -> void:
	body.velocity = body.velocity.move_toward(Vector2.ZERO, delta * movement.knock_back_resistance)
	body.move_and_slide()


func _on_hurt_box_area_entered(area: Hazard) -> void:
	if area == own_hit_box:
		return

	# TODO: other states should monitor for this event instead
	state_machine.transition("KnockBack")
	_knockback_vector = (body.global_position - area.global_position).normalized() * area.knockback_force
	body.velocity = _knockback_vector
