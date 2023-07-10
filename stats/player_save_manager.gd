class_name PlayerSaveManager
extends Node

const path = "user://bagel.tres"

var data: SaveData = null

func _ready() -> void:
	load_data()


func load_data() -> void:
	if ResourceLoader.exists(path):
		data = ResourceLoader.load(path)
		return
	data = SaveData.new()


func save_data() -> void:
	ResourceSaver.save(data, path)
