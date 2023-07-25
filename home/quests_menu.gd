class_name QuestsMenu
extends ShopMenu

@onready var _quest_grid: QuestGrid = $"ScrollContainer/MarginContainer/VBoxContainer/CenterContainer/QuestGrid"
@onready var _no_quests_label: Label = $"ScrollContainer/MarginContainer/VBoxContainer/CenterContainer/NoQuestsLabel"

func enter() -> void:
	super.enter()
	_quest_grid.quests = SaveManager.data.available_quests
	_no_quests_label.visible = SaveManager.data.available_quests.size() == 0
	_quest_grid.focus_first_cell()


func _refresh() -> void:
	_no_quests_label.visible = SaveManager.data.available_quests.size() == 0
	_quest_grid.refresh_grid()


func _on_quest_grid_cell_accepted(cell: QuestCell) -> void:
	SaveManager.data.accepted_quests.push_back(cell.quest)
	_refresh()


func _on_quest_grid_cell_dismissed(cell) -> void:
	var available_index = SaveManager.data.available_quests.find(cell.quest)
	var accepted_index = SaveManager.data.accepted_quests.find(cell.quest)

	if available_index >= 0:
		SaveManager.data.available_quests.remove_at(available_index)

	if accepted_index >= 0:
		SaveManager.data.accepted_quests.remove_at(accepted_index)

	_refresh()
