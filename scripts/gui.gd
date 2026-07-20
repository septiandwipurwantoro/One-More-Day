extends Control
class_name GUI

@onready var advance_day_confimation_panel: PanelContainer = $AdvanceDayConfimationPanel
@onready var date_label: Label = %DateLabel
@onready var health_bar: ProgressBar = %HealthBar
@onready var gold_label: Label = %GoldLabel
@onready var water_container: HBoxContainer = %WaterContainer
@onready var potion_container: HBoxContainer = %PotionContainer
@onready var return_button: PanelContainer = $ReturnButton

@onready var main_menu_scene := "res://scenes/main_menu.tscn"

var _displayed_gold: int = 0
var gold_tween: Tween

func _ready() -> void:
	GameState.day_advanced.connect(_on_day_advanced)
	PlayerStats.health_changed.connect(_on_health_changed)
	Inventory.gold_changed.connect(_on_gold_changed)
	Inventory.water_changed.connect(_on_water_changed)
	Inventory.potion_changed.connect(_on_potion_changed)
	
	_on_day_advanced()
	
	health_bar.max_value = PlayerStats.MAX_HEALTH
	_on_health_changed(PlayerStats.MAX_HEALTH)
	
	_update_gold_text(Inventory.gold)
	_on_water_changed(Inventory.water)
	_on_potion_changed(Inventory.potion)

func _on_day_advanced() -> void:
	date_label.text = GameState.get_current_date()
	
func _on_health_changed(amount: float) -> void: health_bar.value = amount

func _on_gold_changed(amount: int) -> void:
	var old_gold := _displayed_gold
	
	if gold_tween:
		gold_tween.kill()
	
	gold_tween = create_tween()
	gold_tween.set_parallel(true)
	
	gold_tween.tween_method(
		_update_gold_text, 
		old_gold, 
		amount, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	gold_label.scale = Vector2(1.3, 1.3)
	gold_tween.tween_property(
		gold_label, 
		"scale", 
		Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		
	var flash_color := Color.GREEN if amount > old_gold else Color.RED
	gold_label.modulate = flash_color
	gold_tween.tween_property(
		gold_label, 
		"modulate", 
		Color.WHITE, 0.4).set_delay(0.05)

	_displayed_gold = amount

func _update_gold_text(value: float) -> void:
	gold_label.text = str(int(round(value)))

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

func _on_pause_button_button_up() -> void:
	GameState.input_enable = false
	return_button.show()
	
func _on_no_return_button_button_up() -> void:
	GameState.input_enable = true
	return_button.hide()

func _on_yes_return_button_button_up() -> void:
	GameState.input_enable = true
	Transition.change_scene(main_menu_scene)
