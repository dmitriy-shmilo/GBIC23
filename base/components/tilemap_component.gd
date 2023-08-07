class_name TileMapComponent
extends Node

@export var tilemap: TileMap = null

func current_tile_depth() -> int:
	var global_position = owner.global_position
	var local_position = tilemap.to_local(global_position)
	var tile_position = tilemap.local_to_map(local_position)
	var tile_data = tilemap.get_cell_tile_data(0, tile_position)
	return tile_data.get_custom_data("depth")
