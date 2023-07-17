## workaround for https://github.com/godotengine/godot/issues/75422
class_name RootScene
extends Node

const STARTING_SCENE = preload("res://home/hub.tscn")

func _ready() -> void:
	SceneManager.scene_change_requested.connect(_on_scene_change_requested)
	add_child(STARTING_SCENE.instantiate())


func _on_scene_change_requested(path: String) -> void:
	var new_scene = load(path).instantiate()
	var children = get_children()
	for child in children:
		remove_child(child)
		child.queue_free()
	add_child(new_scene)
