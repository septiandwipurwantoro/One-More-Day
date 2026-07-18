extends Interactable

func interact(interactor: Player) -> void:
	if owner is MandrakeField:
		_harvest() if GameState.harvesting else _inspect()
	
func _inspect() -> void:
	var mandrake: Mandrake = owner.planted_mandrake
	UIManager.show_mandrake_status(mandrake)

func _harvest() -> void:
	var mandrake: Mandrake = owner.planted_mandrake
		
