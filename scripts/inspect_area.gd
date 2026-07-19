extends Interactable

var harvesting := false

func interact(inspector: Player) -> void:
	if GameState.harvesting:
		_harvest(inspector) 
	else:
		_inspect(inspector)
	
func _inspect(inspector: Player) -> void:
	if owner is MandrakeField:
		UIManager.show_mandrake_status(inspector, owner)

func _harvest(harvestor: Player) -> void:
	if harvesting: return
	
	harvesting = true
	if owner is MandrakeField:
		var mandrake: Mandrake = owner.planted_mandrake
		if mandrake:
			GameState.input_enable = false
			
			await harvestor.play_interaction()
			owner.pull_out(harvestor)
			
			GameState.input_enable = true
			harvesting = false
		
