extends Objective
class_name FetchWaterObjective

var water_fetched := false

func get_objective_name() -> String:
	return "first_water"

func start_objective() -> void:
	Inventory.water_changed.connect(func(amount: int): water_fetched = true, CONNECT_ONE_SHOT)

func end_objective() -> bool: 
	GameState.set_objective(PlantingObjective.new())
	return true
	
func is_objective_completed() -> bool:
	return water_fetched

func get_objective_text() -> String:
	return "Fetch some water"
