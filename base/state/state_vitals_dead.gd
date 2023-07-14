class_name StateVitalsDead
extends State

func enter(args = {}) -> void:
	owner.queue_free()
