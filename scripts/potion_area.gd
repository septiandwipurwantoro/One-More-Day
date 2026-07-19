extends Interactable

func interact(fetcher: Player) -> void: fetch_potion(fetcher)
func fetch_potion(fetcher: Player) -> void:
	GameState.input_enable = false
	
	await fetcher.play_interaction()
	
	GameState.input_enable = true
	Inventory.supply_potion()
