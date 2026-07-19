extends Control
class_name GUI

@onready var advance_day_confimation_panel: PanelContainer = $AdvanceDayConfimationPanel

func _on_advance_day_button_button_up() -> void:
	advance_day_confimation_panel.show()

func _on_wait_button_button_up() -> void:
	advance_day_confimation_panel.hide()

func _on_yes_button_button_up() -> void:
	GameState.advance_day()
	advance_day_confimation_panel.hide()
