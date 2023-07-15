class_name Product
extends Item

@export var traits: Array[TraitStrength] = []

var _rich_description = ""

func get_item_name() -> String:
	# TODO: more descriptive name
	return tr("it_bagel")


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
