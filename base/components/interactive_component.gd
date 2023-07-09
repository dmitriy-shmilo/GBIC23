class_name InteractiveComponent
extends Area2D

signal interacted(interactor)
signal target_changed(interactor, targets)

var is_targeted = false

func interact(interactor: InteractorComponent) -> void:
	interacted.emit(interactor)


func set_target(interactor: InteractorComponent, target: bool) -> void:
	if is_targeted != target:
		is_targeted = target
		target_changed.emit(interactor, target)
