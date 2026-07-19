extends Interactable

func interact(fetcher: Player) -> void: fetch_water(fetcher)
func fetch_water(fetcher: Player) -> void:
	GameState.input_enable = false
	
	await fetcher.play_interaction()
	
	GameState.input_enable = true
	Inventory.supply_water()
