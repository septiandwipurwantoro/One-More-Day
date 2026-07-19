extends Control
class_name GUI

@onready var advance_day_confimation_panel: PanelContainer = $AdvanceDayConfimationPanel
@onready var date_label: Label = %DateLabel
@onready var water_container: HBoxContainer = %WaterContainer
@onready var potion_container: HBoxContainer = %PotionContainer

func _ready() -> void:
	GameState.day_advanced.connect(_on_day_advanced)
	Inventory.water_changed.connect(_on_water_changed)
	Inventory.potion_changed.connect(_on_potion_changed)
	_on_day_advanced()
	_on_water_changed(Inventory.water)
	_on_potion_changed(Inventory.potion)

func _on_day_advanced() -> void:
	date_label.text = GameState.get_current_date()
	
func _on_water_changed(amount: int) -> void:
	var water_counter := amount
	for water in water_container.get_children():
		if water is ColorRect:
			if water_counter > 0:
				water.color = Color.SKY_BLUE
				water_counter -= 1
				continue
			
			water.color = Color.ROYAL_BLUE.darkened(0.5)
	
func _on_potion_changed(amount: int) -> void:
	var potion_counter := amount
	for potion in potion_container.get_children():
		if potion is ColorRect:
			if potion_counter > 0:
				potion.color = Color.CRIMSON
				potion_counter -= 1
				continue
			
			potion.color = Color.DARK_RED.darkened(0.5)

func _on_advance_day_button_button_up() -> void:
	if GameState.input_enable: advance_day_confimation_panel.show()

func _on_wait_button_button_up() -> void:
	advance_day_confimation_panel.hide()

func _on_yes_button_button_up() -> void:
	GameState.advance_day()
	advance_day_confimation_panel.hide()
