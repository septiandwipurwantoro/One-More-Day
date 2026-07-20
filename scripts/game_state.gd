extends Node

signal day_advanced
signal  objective_set_up(objective: Objective)
signal objective_completed

var input_enable := true

var day_counter := 1
var month_counter := 1

var mandrake_fields: Dictionary[MandrakeField, Mandrake]
var harvesting := false

var current_objective: Objective
var completed_objectives: Dictionary[String, bool]

func _process(delta: float) -> void:
	if current_objective:
		if current_objective.is_objective_completed():
			_objective_completed()

func advance_day() -> void:
	var today_date = get_current_date()
	_turn_next_day()
	
	UIManager.close_the_day(today_date, get_current_date())
	
	await UIManager.day_closed
	day_advanced.emit()

func _turn_next_day() -> void:
	day_counter += 1
	if day_counter <= 30: return
	
	day_counter = 1
	month_counter += 1
	if month_counter <= 12: return
	
	month_counter = 1

func is_today_date(day: int, month: int) -> bool:
	return true if day_counter == day and month_counter == month else false

func get_current_date() -> String:
	return "%d / %d" % [day_counter, month_counter]

func harvest(harvested_mandrake: Mandrake, harvester: Player) -> void:
	harvesting = true
	for mandrake_field in mandrake_fields:
		var mandrake: Mandrake = mandrake_fields[mandrake_field]
		if mandrake_field is MandrakeField:
			mandrake_field.scream()
			
		if mandrake == harvested_mandrake: mandrake_field.pull_out(harvester)

func set_objective(objective: Objective) -> bool:
	if current_objective and not current_objective.is_objective_completed(): 
		return false
	
	current_objective = objective
	current_objective.start_objective()
	objective_set_up.emit(objective)
	return true

func _objective_completed() -> void:
	var make_another_objective = current_objective.end_objective()
	completed_objectives[current_objective.get_objective_name()] = true
	
	if make_another_objective: return
	
	current_objective = null
	objective_completed.emit()
