class_name Level
extends Node2D

const TILE_SIZE = 16
const MIN_SPAWN_DISTANCE = 8

const TERRAIN_LAND = [
	2, # Sand
	2, # Sand
	1, # Grass
	0, # Grass Lush
	0, # Grass Lush
]

const TERRAIN_WATER = [
	2, # Sand (Beach)
	3, # Shallow Water
	4, # Water
	5, # Deep Water
]

const TREES = [
	Vector2i(0, 0),
	Vector2i(1, 0),
	Vector2i(2, 0),
	Vector2i(3, 0),
]

const CHEST_NORMAL = preload("res://items/chest_normal.tres")
const CHEST_RARE = preload("res://items/chest_rare.tres")

const PICKUP_SCENE = preload("res://map/pickup.tscn")
const PLAYER_SCENE = preload("res://player/player.tscn")
const ENEMY_SCENE = preload("res://enemy/enemy.tscn")
const PORTAL_SCENE = preload("res://map/portal.tscn")

@onready var _pause: PauseGui = $"GUI/Pause"
@onready var _portal_menu: PortalMenu = $"GUI/PortalMenu"
@onready var _summary_menu: SummaryMenu = $"GUI/SummaryMenu"
@onready var _tilemap = $"TileMap"
@onready var _objects = $"%Objects"
@onready var _player = $"%Objects/Player"
@onready var _portal = $"%Objects/Portal"

var _moisture = FastNoiseLite.new()
var _altitude = FastNoiseLite.new()
var _vegetation = FastNoiseLite.new()
var _enemies = FastNoiseLite.new()
var _radius = 40

func _ready() -> void:
	_moisture.seed = randi()
	_altitude.seed = randi()
	_vegetation.seed = randi()
	_enemies.seed = randi()
	_moisture.frequency *= 4
	_altitude.frequency *= 4
	_generate_terrain()
	_place_loot()
	_place_player()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_pause.enter(false)


func _place_player() -> void:
	# TODO: spawn randomly off-center
	var start = Vector2.ZERO
	_player.global_position = start + Vector2.DOWN
	_portal.global_position = start



func _is_land(x, y) -> bool:
	var data: TileData = _tilemap.get_cell_tile_data(0, Vector2i(x, y))
	if data == null:
		return true
	var depth = data.get_custom_data("depth")
	return depth <= 0


@warning_ignore("integer_division")
func _place_loot() -> void:
	var retry_count = 10
	var dx = 0
	var dy = 0

	# TODO: determine by difficulty and randomize
	var extra_chest_count = 4

	for r in range(retry_count):
		# guarantee a chest nearby
		dx = randi_range(MIN_SPAWN_DISTANCE, _radius / 6) * [-1, 1].pick_random()
		dy = randi_range(MIN_SPAWN_DISTANCE, _radius / 6) * [-1, 1].pick_random()
		if not _is_land(dx, dy) and r < retry_count - 1:
			continue
		_place_chest(dx, dy, false)
		break

	for i in range(extra_chest_count):
		for r in range(retry_count):
			dx = randi_range(MIN_SPAWN_DISTANCE * 2, _radius / 4 * 3) * [-1, 1].pick_random()
			dy = randi_range(MIN_SPAWN_DISTANCE * 2, _radius / 4 * 3) * [-1, 1].pick_random()
			if not _is_land(dx, dy) and r < retry_count - 1:
				continue
			_place_chest(dx, dy, randi() % 4 > 0)
			break


func _place_chest(x, y, is_rare) -> void:
	var pos = Vector2(x, y)
	var chest = PICKUP_SCENE.instantiate() as Pickup
	chest.item = CHEST_NORMAL if is_rare else CHEST_RARE
	chest.global_position = pos * (0.5 + TILE_SIZE)
	_tilemap.erase_cell(1, pos)
	for cx in range(-2, 2):
		for cy in range(-2, 2):
			if randi() % 2 > 0:
				_tilemap.erase_cell(1, pos + Vector2(cx, cy))
	_objects.add_child(chest)
	_place_guards(pos)


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


@warning_ignore("integer_division")
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
			elif distance <= rsq / 1.2:
				altitude_mod = -0.6
			elif distance < rsq / 1.5:
				altitude_mod = -0.1
			else:
				altitude_mod = -2.0

			var altitude = clampf(_altitude.get_noise_2d(x / 4.0, y / 4.0) * 2 + altitude_mod, -1.0, 1.0)
			var moisture = (_moisture.get_noise_2d(x / 2.0, y / 2.0) + 1.0) / 2.0 * 5.0 # [0 - 5.0]


			if altitude > 0:
				_tilemap.set_cells_terrain_connect(0, [Vector2i(x, y)], 0, TERRAIN_LAND[round(moisture)])
				if moisture > 1.5 and rsq > 4.0:
					var vegetation = _vegetation.get_noise_2d(x * 4.0, y * 4.0)
					if vegetation > 0.4 / moisture:
						_tilemap.set_cell(1, Vector2i(x, y), 0, TREES.pick_random())
			else:
				altitude = 3 - int(round((altitude + 1.0) * 3.0))
				_tilemap.set_cells_terrain_connect(0, [Vector2i(x, y)], 0, TERRAIN_WATER[altitude])


func _on_player_portal_invoked() -> void:
	_portal_menu.enter()


func _on_portal_menu_return_home() -> void:
	_summary_menu.enter()
