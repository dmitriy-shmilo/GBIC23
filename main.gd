class_name Level
extends Node2D


@onready var _tilemap = $"TileMap"

var _moisture = FastNoiseLite.new()
var _altitude = FastNoiseLite.new()
var _temperature = FastNoiseLite.new()

func _ready() -> void:
	_moisture.seed = randi()
	_altitude.seed = randi()
	_moisture.frequency *= 4
	_altitude.frequency *= 4
	for x in range(0, 64):
		for y in range(0, 64):
			var altitude = _altitude.get_noise_2d(x, y)
			var moisture = round((_moisture.get_noise_2d(x, y) + 1.0) / 2.0 * 3.0)

			if altitude > 0:
				_tilemap.set_cell(0, Vector2i(x, y), 1, Vector2i(round(moisture), 0))
			else:
				altitude = (altitude + 1.0) * 3.0
				_tilemap.set_cell(0, Vector2i(x, y), 1, Vector2i(altitude, 3))
