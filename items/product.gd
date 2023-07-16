class_name Product
extends Item

const STRENGTH_PREFIX = [
	"trait_strength_1",
	"trait_strength_1",
	"trait_strength_2",
	"trait_strength_2",
	"trait_strength_3",
	"trait_strength_3",
	"trait_strength_3",
	"trait_strength_4",
	"trait_strength_4",
	"trait_strength_4",
	"trait_strength_5",
	"trait_strength_5",
	"trait_strength_5",
	"trait_strength_6",
]
const BASE_PRICE = 2

@export var traits: Array[TraitStrength] = []

var _rich_description = ""
var _rich_name = ""
var _price = 0

func get_selling_price() -> int:
	if _price == 0:
		_price = BASE_PRICE
		_price += traits.size()
		for t in traits:
			_price += t.strength
	return _price


func get_item_name() -> String:
	if _rich_name == "":
		if traits.size() == 0:
			_rich_name = "%s %s" % [tr("trait_plain"), tr("it_bagel")]
		else:
			var t = traits[0]
			_rich_name = "%s %s %s" % [
				tr(STRENGTH_PREFIX[clamp(t.strength, 0, STRENGTH_PREFIX.size() - 1)]),
				tr(t.item_trait.loc_name),
				tr("it_bagel")
			]
	return _rich_name


func get_item_description() -> String:
	if _rich_description == "":
		_rich_description = tr(loc_description)
		if _rich_description != "":
			_rich_description += "\n"
		for i in range(traits.size()):
			var t = traits[i]
			var strength = "%s%d" % ["" if t.strength < 0 else "+",
				t.strength]
			var name = tr(t.item_trait.loc_name)
			_rich_description += "%s %s%s" % [strength,
				name,
				"" if i == traits.size() - 1 else "\n"]
	return _rich_description


func clear_traits() -> void:
	traits.clear()
	_rich_description = ""
	_rich_name = ""
