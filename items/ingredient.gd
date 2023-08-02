class_name Ingredient
extends Item

# TODO: replace with TraitStrength
@export var traits: Array[Trait] = []
@export var trait_strength: Array[int] = []

var _rich_description = ""

func get_item_description() -> String:
	if _rich_description == "":
		_rich_description = tr(loc_description)
		if _rich_description != "":
			_rich_description += "\n"
		for i in range(traits.size()):
			var t = traits[i]
			var strength = "%s%d" % ["" if trait_strength[i] < 0 else "+",
				trait_strength[i]]
			_rich_description += "%s %s%s" % [strength,
				tr(t.loc_name),
				"" if i == traits.size() - 1 else "\n"]
	return _rich_description


func _calculate_purchase_price() -> int:
	var trait_count = traits.size()
	var trait_total = trait_strength.reduce(func (a, b): return a + b, 0)
	return max(trait_count, 2) * max(4, trait_total) / 2


func _calculate_sell_price() -> int:
	var trait_count = traits.size()
	var trait_total = trait_strength.reduce(func (a, b): return a + b, 0)
	return max(1, max(trait_count, 1) * max(1, trait_total) / 3)
