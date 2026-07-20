extends Interactable

@export var idle_dialogue: DialogueResource
@export var sell_mandrakes_dialogue: DialogueResource

func interact(customer: Player) -> void:
	if Inventory.has_harvested_mandrakes():
		_sell_mandrakes(customer)
		return
		
	_idle_interaction()
	
func _idle_interaction() -> void:
	DialogueManager.show_dialogue_balloon(idle_dialogue, "start")

func _sell_mandrakes(customer: Player) -> void:
	GameState.input_enable = false
	
	DialogueManager.show_dialogue_balloon(sell_mandrakes_dialogue, "start")
	await DialogueManager.dialogue_ended
	
	GameState.harvesting = false
	GameState.input_enable = true
