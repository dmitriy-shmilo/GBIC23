class_name Consumable
extends Item

enum ConsumableType {
	UNKNOWN,
	HEALTH,
	FOOD
}

@export var strength = 1.0
@export var type := ConsumableType.UNKNOWN
