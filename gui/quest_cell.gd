class_name QuestCell
extends Panel

signal highlighted
signal accepted
signal completed
signal dismissed

@export var quest: Quest = null: set = set_quest

@onready var _description_label: Label = $"DescriptionLabel"
@onready var _reward_label: Label = $"RewardLabel"
@onready var _expiration_label: Label = $"ExpirationLabel"
@onready var _accept_button: Button = $"AcceptButton"


func focus_button() -> void:
	_accept_button.grab_focus()


func set_quest(value: Quest) -> void:
	quest = value
	if is_inside_tree():
		_description_label.text = quest.get_description()
		_reward_label.text = "%d" % quest.get_reward()
		_expiration_label.text = "%d" % quest.expiration_day

		# TODO: change button icon
		if not is_accepted():
			_accept_button.disabled = false
			_accept_button.text = tr("ui_quest_accept")
		else:
			_accept_button.text = tr("ui_quest_complete")
			_accept_button.disabled = not can_complete()


func is_accepted() -> bool:
	return SaveManager.data.accepted_quests.has(quest)


func can_complete() -> bool:
	if SaveManager.data.storage_inventory.any(func (p): return p is Product and quest.is_match(p)):
		return true
	if SaveManager.data.counter_inventory.any(func (p): return p is Product and quest.is_match(p)):
		return true

	return false


func _on_accept_button_pressed() -> void:
	if not is_accepted():
		accepted.emit()
	else:
		completed.emit()


func _on_dismiss_button_pressed() -> void:
	dismissed.emit()
