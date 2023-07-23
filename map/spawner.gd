class_name Spawner
extends Node2D

const ENEMY_SCENE = preload("res://enemy/enemy.tscn")
const TILE_SIZE = 16.0
@export var descriptions: Array[EnemyDescription] = [
	preload("res://enemy/descriptions/grunt_0.tres")
]
@export var spawn_time = 10.0
@export var max_spawns = 2

var _current_spawns = 0
var _current_spawn_time = 0.0

func _physics_process(delta: float) -> void:
	if _current_spawns > max_spawns:
		return

	_current_spawn_time += delta
	if _current_spawn_time >= spawn_time:
		_current_spawn_time = 0
		_spawn()
		_current_spawns += 1


func _spawn() -> void:
	var positions = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
	var enemy = ENEMY_SCENE.instantiate() as Enemy
	enemy.description = descriptions.pick_random()
	var offset = positions.pick_random() * (randi() % 3 + 1)
	enemy.global_position = global_position + Vector2(randf_range(-2.0, 2.0), randf_range(-2.0, 2.0)) * TILE_SIZE
	enemy.died.connect(_on_enemy_died)
	# assuming parent is the map objects container
	get_parent().add_child(enemy)


func _on_enemy_died() -> void:
	_current_spawns -= 1
