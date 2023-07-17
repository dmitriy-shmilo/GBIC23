class_name SceneManagerAutoload
extends Node

signal scene_change_requested(path: String)

func change_scene(path: String) -> void:
	scene_change_requested.emit(path)
