class_name Hub
extends Control



func _on_quit_button_pressed() -> void:
	# TODO: save
	get_tree().quit()


func _on_portal_shop_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
