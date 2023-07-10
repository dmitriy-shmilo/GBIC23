class_name PortalShop
extends HubShop


func _on_portal_back_button_pressed() -> void:
	back_pressed.emit()


func _on_portal_buy_button_pressed() -> void:
	# TODO: shop options
	get_tree().change_scene_to_file("res://main.tscn")
