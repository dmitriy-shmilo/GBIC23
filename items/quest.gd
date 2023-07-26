class_name Quest
extends Resource

const BASE_REWARD = 5
const MAX_REQ_TRAITS = 3
const MAX_REQ_STRENHGTH = 14
const REQ_TRAIT_COUNT_MULTIPLIER = 3
const MAX_BAD_TRAITS = 2
const BAD_TRAIT_COUNT_MULTIPLIER = 8
const RANDOM_BONUS = 20

static func generate(duration: int, has_bad: bool, max_strength: int, preferred_trait: Trait) -> Quest:
	var result = Quest.new()
	var traits = [
		preload("res://items/traits/citrus.tres"),
		preload("res://items/traits/creamy.tres"),
		preload("res://items/traits/fatty.tres"),
		preload("res://items/traits/fresh.tres"),
		preload("res://items/traits/fruity.tres"),
		preload("res://items/traits/juicy.tres"),
		preload("res://items/traits/meaty.tres"),
		preload("res://items/traits/nutty.tres"),
		preload("res://items/traits/salty.tres"),
		preload("res://items/traits/sour.tres"),
		preload("res://items/traits/spicy.tres"),
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
		result.required_traits.push_back(ts)

	result.required_traits.sort_custom(func(a, b): return a.strength > b.strength)

	for i in range(bad_count):
		result.bad_traits.push_back(traits.pop_back())

	result.expiration_day = SaveManager.data.date + duration
	return result

@export var required_traits: Array[TraitStrength] = []
@export var bad_traits: Array[Trait] = []
@export var expiration_day: int = 0

var _product: Product = null
var _reward = 0
var _description = ""

func get_reward() -> int:
	if _reward == 0:
		_reward = BASE_REWARD + randi_range(0, RANDOM_BONUS)
		_reward += required_traits.size() * REQ_TRAIT_COUNT_MULTIPLIER
		_reward += bad_traits.size() * BAD_TRAIT_COUNT_MULTIPLIER

		var req_multiplier = max((required_traits.size() + bad_traits.size()) / 1.2, 0.75)
		for req in required_traits:
			_reward += floor(req.strength * req_multiplier)

	return _reward


func get_description() -> String:
	if _description == "":
		_description = get_product().get_item_name().capitalize() + "\n"

		for i in range(required_traits.size()):
			var t = required_traits[i]
			_description += "+%d %s" % [t.strength, tr(t.item_trait.loc_name)]
			if i < required_traits.size() - 1:
				_description += ","

		if bad_traits.size() > 0:
			_description += "\n" + tr("ui_quest_without") + ": "
			for i in range(bad_traits.size()):
				var t = bad_traits[i]
				_description += tr(t.loc_name)
				if i < bad_traits.size() - 1:
					_description += ","

	return _description


func is_match(product: Product) -> bool:
	for bad_trait in bad_traits:
		if product.traits.any(func(t): return t.item_trait == bad_trait):
			return false

	for req_trait in required_traits:
		if product.traits.all(func(t): return t.item_trait != req_trait.item_trait or t.strength < req_trait.strength):
			return false

	return true


func get_product() -> Product:
	if _product == null:
		_product = Product.new()
		_product.traits = required_traits
	return _product
