extends Objective
class_name PlantingObjective

var planter_counter := 0

func get_objective_name() -> String:
	return "first_plant"

func start_objective() -> void:
	planter_counter = GameState.mandrake_fields.size()

func end_objective() -> bool: 
	GameState.set_objective(EndTheDayObjective.new())
	return true

func is_objective_completed() -> bool:
	return true if GameState.mandrake_fields.size() >= planter_counter + 2 else false

func get_objective_text() -> String:
	return "Plant 2 mandrake seeds"
