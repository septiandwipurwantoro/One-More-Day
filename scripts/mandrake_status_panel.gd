extends Control
class_name MandrakeStatusPanel

@onready var plant_button: Button = %PlantButton
@onready var water_button: Button = %WaterButton
@onready var use_potion_button: Button = %UsePotionButton
@onready var harvest_button: Button = %HarvestButton

func show_panel(mandrake: Mandrake) -> void:
	show()
	_setup_buttons(mandrake)
	
func _setup_buttons(mandrake: Mandrake) -> void:
	_hide_all_buttons()
	if mandrake:
		water_button.show()
		use_potion_button.show()
		water_button.button_up.connect(mandrake.water_mandrake)
		use_potion_button.button_up.connect(mandrake.potion_mandrake)
		
		if mandrake.current_state == Mandrake.Maturity.MATURE: 
			harvest_button.show()
			harvest_button.button_up.connect(GameState.harvest)
		return
	
	plant_button.show()
	
func _hide_all_buttons() -> void:
	plant_button.hide()
	water_button.hide()
	use_potion_button.hide()
	harvest_button.hide()

func _on_leave_button_button_up() -> void: hide()
