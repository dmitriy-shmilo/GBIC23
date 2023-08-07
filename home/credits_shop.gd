class_name CreditsShop
extends HubShop

const CREDITS = [
	["ui_credits_famicase"],
	["'Bagel Quest'", "https://famicase.com/23/softs/058.html", "Stephen Kissel"],
	["ui_credits_art"],
	["'16x16 food'", "https://opengameart.org/content/16x16-food", "ARoachIFoundOnMyPillow"],
	["'16x16 mini world sprites'", "https://merchant-shade.itch.io/16x16-mini-world-sprites", "merchant-shade"],
	["ui_credits_font"],
	["'monogram'", "https://datagoblin.itch.io/monogram", "datagoblin"],
	["'monogram ua'", "https://dmitriy-shmilo.itch.io/monogram-ua", "Dmitriy Shmilo"],
	["ui_credits_sound"],
	["'512 Sound Effects (8-bit style)'", "https://opengameart.org/content/512-sound-effects-8-bit-style", "SubspaceAudio"],
	["ui_credits_other"],
	["'Made with'", "https://godotengine.org/", "Godot 4 Engine"],
	["'Code and other knick-knacks'", "https://dmitriy-shmilo.itch.io/", "Dmitriy Shmilo"]
]

@onready var _credits_label: RichTextLabel = %"CreditsLabel"
var _credits_text = ""

func _ready() -> void:
	for arr in CREDITS:
		if arr.size() == 1:
			_credits_text += "\n[color=white]" + tr(arr[0]) + "[/color]\n"
		elif arr.size() == 3:
			var title = arr[0]
			var url = arr[1]
			var author = arr[2]

			var line = ""
			if author != "":
				line = tr("ui_credits_by") % [title, url, author]
			_credits_text += line + "\n"

	_credits_label.text = _credits_text



func _on_credits_label_meta_clicked(meta: String) -> void:
	OS.shell_open(meta)
