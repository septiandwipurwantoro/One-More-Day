extends Node2D

@export var intro_dialogue: DialogueResource

func _ready() -> void:
	if GameState.is_today_date(1, 1):
		GameState.input_enable = false
		UIManager.enable_overlay()
		UIManager.hide_gui()
		
		DialogueManager.show_dialogue_balloon(intro_dialogue, "start")
		await DialogueManager.dialogue_ended
		
		UIManager.show_gui()
		GameState.set_objective(FetchWaterObjective.new())
		GameState.input_enable = true
