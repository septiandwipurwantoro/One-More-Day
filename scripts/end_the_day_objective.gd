extends Objective
class_name EndTheDayObjective

var day_advanced := false

func start_objective() -> void:
	GameState.day_advanced.connect(func(): day_advanced = true)
	
func is_objective_completed() -> bool:
	return true if day_advanced else false

func end_objective() -> bool:
	return false
	
func get_objective_name() -> String:
	return "first day"
	
func get_objective_text() -> String:
	return "End the day"
