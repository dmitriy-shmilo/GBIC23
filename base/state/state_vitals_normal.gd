class_name StateVitalsNormal
extends State

@export var hurt_box: Area2D = null
@export var vitals: VitalsComponent = null
@export var own_hit_box: Hazard = null

func _ready() -> void:
	hurt_box.connect("area_entered", _on_hurt_box_area_entered)


func _on_hurt_box_area_entered(area: Hazard) -> void:
	if area == own_hit_box or state_machine.current_state != self:
		return
	vitals.current_health -= area.damage
	if vitals.current_health > 0:
		state_machine.transition("Invulnerable")
	else:
		state_machine.transition("Dying")

