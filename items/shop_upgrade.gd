class_name ShopUpgrade
extends Resource


@export var loc_name = ""
@export var loc_description = ""
@export var icon: Texture = null
@export var base_price = 1
@export var prerequisites: Array[ShopUpgrade] = []

var _rich_description = ""

func get_rich_description() -> String:
	if _rich_description == "":
		var text = "%s\n%s" % [tr(loc_name), tr(loc_description)]

		if prerequisites.size() > 0:
			text += "\n%s: " % tr("ui_prerequisites")
			for i in range(prerequisites.size()):
				var preq = prerequisites[i]
				text += "[img]%s[/img]%s" % [preq.icon.resource_path, tr(preq.loc_name)]
				if i != prerequisites.size() - 1:
					text += ", "
		_rich_description = text

	return _rich_description
