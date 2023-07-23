class_name SceneManagerAutoload
extends Node

signal scene_change_requested(path: String, options: Resource)

func change_scene(path: String, options: Resource = null) -> void:
	scene_change_requested.emit(path, options)
