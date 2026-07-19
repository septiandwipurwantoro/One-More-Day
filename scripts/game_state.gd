extends Node

signal day_advanced

var input_enable := true

var day_counter := 1
var month_counter := 1

var mandrake_fields: Dictionary[MandrakeField, Mandrake]
var harvesting := false

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

func get_current_date() -> String:
	return "%d / %d" % [day_counter, month_counter]

func harvest(harvested_mandrake: Mandrake, harvester: Player) -> void:
	harvesting = true
	for mandrake_field in mandrake_fields:
		var mandrake: Mandrake = mandrake_fields[mandrake_field]
		if mandrake_field is MandrakeField:
			mandrake_field.scream()
			
		if mandrake == harvested_mandrake: mandrake_field.pull_out(harvester)
