class_name Ingredient
extends Item

@export var traits: Array[Trait] = []
@export var trait_strength: Array[int] = []

var _rich_description = ""

func get_rich_description() -> String:
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
