class_name EnemyStateKnockedBack
extends StateKnockedBack

@export var aggro_area: AggroArea = null


func physics_process(delta: float) -> void:
	super.physics_process(delta)
	if body.velocity.length_squared() <= 0.1:
		if aggro_area.has_overlapping_bodies():
			state_machine.transition("Chase")
		else:
			state_machine.transition("Wonder")
