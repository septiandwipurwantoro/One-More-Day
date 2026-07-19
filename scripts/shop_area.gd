extends Interactable

@export var shop_dialogue: DialogueResource

func interact(customer: Player) -> void: _shop()
func _shop() -> void:
	DialogueManager.show_dialogue_balloon(shop_dialogue, "start")
