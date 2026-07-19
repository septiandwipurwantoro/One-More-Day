extends Node2D
class_name MandrakeField

@onready var mandrake_sprite: AnimatedSprite2D = $MandrakeSprite

var planted_mandrake: Mandrake

func plant() -> void:
	planted_mandrake = Mandrake.new()
	planted_mandrake.maturity_changed.connect(_on_maturity_changed)
	
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

func _on_maturity_changed(maturity: Mandrake.Maturity) -> void:
	match maturity:
		Mandrake.Maturity.SEED:
			mandrake_sprite.play("seed")
		Mandrake.Maturity.SPROUT:
			mandrake_sprite.play("sprout")
		Mandrake.Maturity.YOUNG:
			mandrake_sprite.play("young")
		Mandrake.Maturity.MATURE:
			mandrake_sprite.play("mature")
