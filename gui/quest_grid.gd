class_name QuestGrid
extends GridContainer

const QUEST_CELL = preload("res://gui/quest_cell.tscn")

signal cell_highlighted(cell: QuestCell)
signal cell_accepted(cell: QuestCell)
signal cell_dismissed(cell: QuestCell)
signal cell_completed(cell: QuestCell)

@export var quests: Array[Quest] = []: set = set_quests


func set_quests(value: Array[Quest]) -> void:
	quests = value
	if is_inside_tree():
		refresh_grid()


func focus_first_cell() -> void:
	if get_child_count() > 0 and get_child(0).visible:
		get_child(0).focus_button()


func refresh_grid() -> void:
	var existing_count = get_child_count()
	var item_count = quests.size()

	# add missing cells
	if existing_count < item_count:
		for i in range(existing_count, item_count):
			var cell = QUEST_CELL.instantiate()
			cell.accepted.connect(_on_cell_accepted.bind(cell))
			cell.dismissed.connect(_on_cell_dismissed.bind(cell))
			cell.completed.connect(_on_cell_completed.bind(cell))
			cell.highlighted.connect(_on_cell_highlighted.bind(cell))
			add_child(cell)
	else:
		for i in range(item_count, existing_count):
			get_child(i).visible = false

	for i in range(item_count):
		var quest = quests[i]
		var cell = get_child(i) as QuestCell
		cell.visible = true
		cell.quest = quest


func _on_cell_accepted(cell: QuestCell) -> void:
	cell_accepted.emit(cell)


func _on_cell_dismissed(cell: QuestCell) -> void:
	cell_dismissed.emit(cell)


func _on_cell_completed(cell: QuestCell) -> void:
	cell_completed.emit(cell)


func _on_cell_highlighted(cell: QuestCell) -> void:
	cell_highlighted.emit(cell)
