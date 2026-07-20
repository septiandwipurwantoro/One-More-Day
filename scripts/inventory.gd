extends Node

signal gold_changed(amount: int)
signal water_changed(amount: int)
signal potion_changed(amount: int)

var gold := 0
var water := 0
var potion := 0

var harvested_mandrakes: Dictionary[PulledMandrake, Mandrake]

func supply_water() -> void:
	water = 2
	water_changed.emit(water)

func supply_potion() -> void:
	potion = 2
	potion_changed.emit(potion)

func use_water() -> void:
	if water <= 0: return
	water -= 1
	water_changed.emit(water)
	
func use_potion() -> void:
	if potion <= 0: return
	potion -= 1
	potion_changed.emit(potion)
	
func get_total_gold() -> int:
	var total_gold := 0
	for mandrake in harvested_mandrakes.values():
		if mandrake is Mandrake:
			total_gold += mandrake.get_price()
	
	return total_gold

func sell_all_mandrakes() -> void:
	gold += get_total_gold()
	for mandrake in harvested_mandrakes.keys():
		mandrake.queue_free()

	harvested_mandrakes.clear()
	gold_changed.emit(gold)
	
func has_water() -> bool:
	return true if water > 0 else false

func has_potion() -> bool:
	return true if potion > 0 else false

func has_harvested_mandrakes() -> bool:
	return true if harvested_mandrakes.size() > 0 else false
