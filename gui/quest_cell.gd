class_name QuestCell
extends Panel

const ICON_ACCEPT = preload("res://home/icons/icon_quest.tres")
const ICON_COMPLETE = preload("res://home/icons/icon_quest_complete.tres")
const ICON_COMPLETE_DISABLED = preload("res://home/icons/icon_quest_complete_disabled.tres")

signal highlighted
signal accepted
signal completed
signal dismissed

@export var quest: Quest = null: set = set_quest
var is_highlighted: bool:
	get:
		return _accept_button != null and _accept_button.has_focus() \
			or _dismiss_button != null and _dismiss_button.has_focus()
	set(value):
		if _accept_button != null and value:
			_accept_button.grab_focus()


@onready var _item_icon: TextureRect = $"ItemIcon"
@onready var _description_label: Label = $"DescriptionLabel"
@onready var _reward_label: Label = $"RewardLabel"
@onready var _expiration_label: Label = $"ExpirationLabel"
@onready var _accept_button: Button = $"AcceptButton"
@onready var _dismiss_button: Button = $"DismissButton"


func _ready() -> void:
	SaveManager.data.date_changed.connect(_on_date_changed)


func focus_button() -> void:
	_accept_button.grab_focus()


func set_quest(value: Quest) -> void:
	quest = value
	if is_inside_tree() and quest != null:
		var today = SaveManager.data.date
		_description_label.text = quest.get_description()
		_reward_label.text = "%d" % quest.get_reward()
		if quest.expiration_day == today:
			_expiration_label.text = tr("ui_quest_expire_today")
		elif quest.expiration_day == today + 1:
			_expiration_label.text = tr("ui_quest_expire_tomorrow")
		else:
			_expiration_label.text = tr("ui_quest_expire") % SaveManager.data.get_formatted_date(quest.expiration_day)
		_item_icon.modulate = quest.get_product().traits[0].item_trait.color
		if not is_accepted():
			_accept_button.icon = ICON_ACCEPT
			_accept_button.disabled = false
			_accept_button.text = tr("ui_quest_accept")
		else:
			_accept_button.text = tr("ui_quest_complete")
			if can_complete():
				_accept_button.disabled = false
				_accept_button.icon = ICON_COMPLETE
			else:
				_accept_button.disabled = true
				_accept_button.icon = ICON_COMPLETE_DISABLED


func is_accepted() -> bool:
	return SaveManager.data.accepted_quests.has(quest)


func can_complete() -> bool:
	if SaveManager.data.storage_inventory.items.any(func (p): return p is Product and quest.is_match(p)):
		return true
	if SaveManager.data.counter_inventory.items.any(func (p): return p is Product and quest.is_match(p)):
		return true

	return false


func _on_accept_button_pressed() -> void:
	if not is_accepted():
		accepted.emit()
	else:
		completed.emit()


func _on_dismiss_button_pressed() -> void:
	dismissed.emit()


func _on_date_changed(_old, today) -> void:
	if quest == null:
		return
	if quest.expiration_day == today:
		_expiration_label.text = tr("ui_quest_expire_today")
	elif quest.expiration_day == today + 1:
		_expiration_label.text = tr("ui_quest_expire_tomorrow")
	else:
		_expiration_label.text = tr("ui_quest_expire") % SaveManager.data.get_formatted_date(quest.expiration_day)


func _on_accept_button_focus_entered() -> void:
	highlighted.emit()


func _on_dismiss_button_focus_entered() -> void:
	highlighted.emit()
