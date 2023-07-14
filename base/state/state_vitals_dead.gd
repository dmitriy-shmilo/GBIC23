class_name StateVitalsDead
extends State

func enter(_args = {}) -> void:
	owner.queue_free()
