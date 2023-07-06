class_name Level
extends Node2D

const TILE_SIZE = 16

const CHEST_NORMAL = preload("res://items/chest_normal.tres")
const CHEST_RARE = preload("res://items/chest_rare.tres")
const PICKUP_SCENE = preload("res://map/pickup.tscn")
const PLAYER_SCENE = preload("res://player/player.tscn")
const ENEMY_SCENE = preload("res://enemy/enemy.tscn")

@onready var _tilemap = $"TileMap"
@onready var _objects = $"Objects"
@onready var _player = $"Objects/Player"

var _moisture = FastNoiseLite.new()
var _altitude = FastNoiseLite.new()
var _radius = 128

func _ready() -> void:
	_moisture.seed = randi()
	_altitude.seed = randi()
	_moisture.frequency *= 4
	_altitude.frequency *= 4
	_generate_terrain()
	_place_loot()
	_place_player()


func _place_player() -> void:
	# TODO: spawn randomly off-center
	_player.global_position = Vector2(0, 0)
	pass


func _place_loot() -> void:
	# TODO: determine by difficulty and randomize
	var extra_chest_count = 4

	# guarantee a chest nearby
	var dx = randi_range(_radius / 8, _radius / 4) * [-1, 1].pick_random()
	var dy = randi_range(_radius / 8, _radius / 4) * [-1, 1].pick_random()
	var chest = PICKUP_SCENE.instantiate() as Pickup
	# TODO: check if on a solid terrain
	chest.global_position = Vector2(dx, dy) * TILE_SIZE
	chest.item = CHEST_NORMAL
	add_child(chest)

	_place_guards(Vector2(dx, dy))

	for i in range(extra_chest_count):
		dx = randi_range(_radius / 4, _radius / 4 * 3) * [-1, 1].pick_random()
		dy = randi_range(_radius / 4, _radius / 4 * 3) * [-1, 1].pick_random()
		print(dx, dy)
		chest = PICKUP_SCENE.instantiate() as Pickup
		chest.item = CHEST_NORMAL if randi() % 4 > 0 else CHEST_RARE
		chest.global_position = Vector2(dx, dy) * TILE_SIZE
		_objects.add_child(chest)
		_place_guards(Vector2(dx, dy))


func _place_guards(center: Vector2i) -> void:
	# TODO: base on difficulty
	var guard_count = randi() % 3 + 1
	var positions = [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]

	for i in range(guard_count):
		# TODO: enemy resource
		var guard = ENEMY_SCENE.instantiate() as Enemy
		var offset = positions.pick_random() * (randi() % 3 + 1)
		guard.global_position = (center + offset) * TILE_SIZE
		_objects.add_child(guard)


func _generate_terrain() -> void:
	var rsq = _radius * _radius
	for x in range(-_radius, _radius):
		for y in range(-_radius, _radius):
			var distance = Vector2(x, y).length_squared()
			var altitude_mod = 0.0

			# TODO: smoother altitude faloff
			if distance <= 4 * 4:
				altitude_mod = 1.5
			elif distance <= rsq / 64:
				altitude_mod = 0.8
			elif distance <= rsq / 16:
				altitude_mod = 0.6
			elif distance <= rsq / 2:
				altitude_mod = 0.0
			elif distance <= rsq / 4:
				altitude_mod = -0.3
			elif distance < rsq / 1.5:
				altitude_mod = -0.6
			else:
				altitude_mod = -2.0

			var altitude = clampf(_altitude.get_noise_2d(x / 2.0, y / 2.0) * 2 + altitude_mod, -1.0, 1.0)
			var moisture = round((_moisture.get_noise_2d(x / 2.0, y / 2.0) + 1.0) / 2.0 * 3.0)

			if altitude > 0:
				_tilemap.set_cell(0, Vector2i(x, y), 1, Vector2i(round(moisture), 0))
			else:
				altitude = int(round((altitude + 1.0) * 3.0))
				_tilemap.set_cell(0, Vector2i(x, y), 1, Vector2i(altitude, 3))
