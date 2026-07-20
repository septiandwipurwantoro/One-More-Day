extends Objective
class_name DeliverTheHarvestObjective

var gold_counter := 0

func start_objective() -> void:
	gold_counter = Inventory.gold
	
func is_objective_completed() -> bool:
	return true if Inventory.gold > gold_counter else false
	
func end_objective() -> bool:
	return false
	
func get_objective_name() -> String:
	return "first_delivery"
	
func get_objective_text() -> String:
	return "Deliver your mandrakes to The Keeper"
