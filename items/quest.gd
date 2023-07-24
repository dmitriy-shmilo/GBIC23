class_name Quest
extends Resource

const BASE_REWARD = 5
const MAX_REQ_TRAITS = 3
const MAX_REQ_STRENHGTH = 14
const REQ_TRAIT_STRENGTH_MULTIPLIER = 2
const REQ_TRAIT_COUNT_MULTIPLIER = 3
const MAX_BAD_TRAITS = 2
const BAD_TRAIT_COUNT_MULTIPLIER = 8
const RANDOM_BONUS = 20

static func generate(has_bad: bool, max_strength: int, preferred_trait: Trait) -> Quest:
	var result = Quest.new()
	var traits = [
		preload("res://items/traits/citrus.tres"),
		preload("res://items/traits/creamy.tres"),
		preload("res://items/traits/fatty.tres"),
		preload("res://items/traits/fresh.tres"),
		preload("res://items/traits/fruity.tres"),
		preload("res://items/traits/juicy.tres"),
		preload("res://items/traits/salty.tres"),
		preload("res://items/traits/sour.tres"),
		preload("res://items/traits/sweet.tres")
	]
	traits.shuffle()

	if preferred_trait != null:
		var pref_index = traits.find(preferred_trait)
		traits.remove_at(pref_index)
		traits.push_back(preferred_trait)

	var req_count = randi_range(1, MAX_REQ_TRAITS)
	var bad_count = randi_range(0, MAX_BAD_TRAITS) if has_bad else 0

	for i in range(req_count):
		var ts = TraitStrength.new()
		ts.item_trait = traits.pop_back()
		ts.strength = randi_range(1, max_strength)

	for i in range(bad_count):
		result.bad_traits.push_back(traits.pop_back())

	return result

@export var required_traits: Array[TraitStrength] = []
@export var bad_traits: Array[Trait] = []

var _reward = 0

func get_reward() -> int:
	if _reward == 0:
		_reward = BASE_REWARD + randi_range(0, RANDOM_BONUS)
		_reward += required_traits.size() * REQ_TRAIT_COUNT_MULTIPLIER
		_reward += bad_traits.size() * BAD_TRAIT_COUNT_MULTIPLIER

		for req in required_traits:
			_reward += req.strength * REQ_TRAIT_STRENGTH_MULTIPLIER

	return _reward


func is_match(product: Product) -> bool:
	for bad_trait in bad_traits:
		if product.traits.any(func(t): t.item_trait == bad_trait):
			return false

	for req_trait in required_traits:
		if product.traits.all(func(t): t.item_trait != req_trait or t.strength < req_trait.strength):
			return false

	return true
