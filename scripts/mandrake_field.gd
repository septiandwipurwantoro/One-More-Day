extends Node2D
class_name MandrakeField

var planted_mandrake: Mandrake

func plant() -> void:
	planted_mandrake = Mandrake.new()
	planted_mandrake.create()
	GameState.mandrake_fields[self] = planted_mandrake

func scream() -> void:
	pass

func pull_out() -> void:
	GameState.mandrake_fields.erase(planted_mandrake)
	planted_mandrake = null

func advance_day() -> void:
	if planted_mandrake:
		planted_mandrake.advance_day()
