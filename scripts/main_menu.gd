extends Control

@onready var mandrake_garden_scene := "res://scenes/mandrake_garden.tscn"

func _ready() -> void:
	UIManager.hide_gui()

func _on_start_game_button_button_up() -> void:
	Transition.change_scene(mandrake_garden_scene)

func _on_exit_button_button_up() -> void:
	get_tree().quit()
