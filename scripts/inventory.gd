extends Node

signal water_changed(amount: int)
signal potion_changed(amount: int)

var gold := 0
var water := 0
var potion := 0

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

func has_water() -> bool:
	return true if water > 0 else false

func has_potion() -> bool:
	return true if potion > 0 else false
	
