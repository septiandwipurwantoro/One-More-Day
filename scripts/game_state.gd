extends Node

var day_counter := 1
var month_counter := 1

func turn_next_day() -> void:
	day_counter += 1
	if day_counter <= 30: return
	
	day_counter = 1
	month_counter += 1
	if month_counter <= 12: return
	
	month_counter = 1
		

func get_current_date() -> String:
	return "%d / %d" % [day_counter, month_counter]
