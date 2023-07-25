class_name QuestsMenu
extends ShopMenu

@onready var _quest_grid: QuestGrid = $"ScrollContainer/MarginContainer/VBoxContainer/CenterContainer/QuestGrid"

func enter() -> void:
	super.enter()
	_quest_grid.quests = SaveManager.data.available_quests
