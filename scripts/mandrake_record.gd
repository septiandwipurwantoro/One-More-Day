extends HBoxContainer
class_name MandrakeRecord

@onready var date_label: RichTextLabel = $DateLabel
@onready var record_label: RichTextLabel = $RecordLabel

func setup(entry: Dictionary) -> void:
	date_label.text = entry["date"]
	record_label.text = entry["record"]
