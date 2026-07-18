extends Interactable

func interact(interactor: Player) -> void:
	if owner is MandrakeField:
		_harvest() if GameState.harvesting else _inspect()
	
func _inspect() -> void:
	UIManager.show_mandrake_status(owner)

func _harvest() -> void:
	var mandrake: Mandrake = owner.planted_mandrake
		
