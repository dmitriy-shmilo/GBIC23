class_name Consumable
extends Item

enum ConsumableType {
	UNKNOWN,
	HEALTH,
	FOOD
}

@export var strength = 1.0
@export var type := ConsumableType.UNKNOWN

func _calculate_purchase_price() -> int:
	return max(5, strength * 10 + price_modifier)

func _calculate_sell_price() -> int:
	return max(1, strength * 2 + price_modifier)
