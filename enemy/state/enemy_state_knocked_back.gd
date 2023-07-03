class_name EnemyStateKnockedBack
extends State

@export var hurt_box: Area2D = null
@export var body: CharacterBody2D = null
@export var vitals: VitalsComponent = null
@export var aggro_area: AggroArea = null
@export var own_hit_box: Hazard = null

const KNOCKBACK_FORCE = 100.0
const KNOCBACK_FRICTION = 150.0

var _knockback_vector: Vector2 = Vector2.ZERO


func _ready() -> void:
	hurt_box.connect("area_entered", _on_hurt_box_area_entered)


func physics_process(delta: float) -> void:
	body.velocity = body.velocity.move_toward(Vector2.ZERO, delta * KNOCBACK_FRICTION)
	body.move_and_slide()
	if body.velocity.length_squared() <= 0.1:
		if aggro_area.has_overlapping_bodies():
			state_machine.transition("Chase")
		else:
			state_machine.transition("Wonder")


func _on_hurt_box_area_entered(area: Hazard) -> void:
	if area == own_hit_box:
		return
	state_machine.transition("KnockBack")
	_knockback_vector = (body.global_position - area.global_position).normalized() * KNOCKBACK_FORCE
	body.velocity = _knockback_vector

	# TODO: this should probably be handled in a separate machine
	vitals.current_health -= area.damage
	if vitals.current_health <= 0:
		body.queue_free()
