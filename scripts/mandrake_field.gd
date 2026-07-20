extends Node2D
class_name MandrakeField

@export var pulled_mandrake_scene: PackedScene

@onready var mandrake_sprite: AnimatedSprite2D = $MandrakeSprite

var planted_mandrake: Mandrake

func _ready() -> void:
	GameState.day_advanced.connect(_on_day_advanced)

func plant() -> void:
	planted_mandrake = Mandrake.new()
	planted_mandrake.maturity_changed.connect(_on_maturity_changed)
	
	planted_mandrake.create()
	GameState.mandrake_fields[self] = planted_mandrake
	
	mandrake_sprite.show()

func scream() -> void:
	pass

func pull_out(harvester: Player) -> void:
	var pulled_mandrave = _spawn_pulled_mandrake(harvester)
	
	GameState.mandrake_fields.erase(self)
	Inventory.harvested_mandrakes[pulled_mandrave] = planted_mandrake
	
	planted_mandrake = null
	mandrake_sprite.hide()

func _spawn_pulled_mandrake(harvester: Player) -> PulledMandrake:
	var pulled_mandrake: PulledMandrake = pulled_mandrake_scene.instantiate()
	pulled_mandrake.setup(harvester, planted_mandrake)
	get_tree().current_scene.add_child(pulled_mandrake)
	
	return pulled_mandrake

func _on_day_advanced() -> void:
	if planted_mandrake:
		planted_mandrake.advance_day()
	
		mandrake_sprite.scale = Vector2.ONE * planted_mandrake.get_weight_multiplier() * 0.5

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
