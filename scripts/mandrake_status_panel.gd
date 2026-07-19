extends Control
class_name MandrakeStatusPanel

@export var mandrake_record_scene: PackedScene

@onready var plant_button: Button = %PlantButton
@onready var water_button: Button = %WaterButton
@onready var use_potion_button: Button = %UsePotionButton
@onready var harvest_button: Button = %HarvestButton
@onready var leave_button: Button = %LeaveButton

@onready var mandrake_records: VBoxContainer = %MandrakeRecords

var _current_field: MandrakeField

func setup_panel(field: MandrakeField) -> void:
	_current_field = field
	_setup_records()
	_refresh_buttons()

func _setup_records() -> void:
	_remove_all_records()
	var mandrake: Mandrake = _current_field.planted_mandrake
	if mandrake:
		var records := mandrake.records
		if records:
			for record in records:
				var mandrake_record: MandrakeRecord = mandrake_record_scene.instantiate()
				mandrake_records.add_child(mandrake_record)
				mandrake_record.setup(record)
			
			return
		
		
		
func _remove_all_records() -> void:
	for record in mandrake_records.get_children():
		record.queue_free() 

func _refresh_buttons() -> void:
	var mandrake: Mandrake = _current_field.planted_mandrake

	_hide_all_buttons()

	if mandrake:
		if not mandrake.cared_today:
			water_button.show()
			use_potion_button.show()

		if mandrake.current_state == Mandrake.Maturity.MATURE:
			harvest_button.show()
			
		return
		
	plant_button.show()

func _hide_all_buttons() -> void:
	plant_button.hide()
	water_button.hide()
	use_potion_button.hide()
	harvest_button.hide()

func _on_plant_button_button_up() -> void:
	_current_field.plant()
	_refresh_buttons()
	_setup_records()

func _on_water_button_button_up() -> void:
	_current_field.planted_mandrake.water_mandrake()
	_refresh_buttons()
	_setup_records()

func _on_use_potion_button_button_up() -> void:
	_current_field.planted_mandrake.potion_mandrake()
	_refresh_buttons()
	_setup_records()

func _on_harvest_button_button_up() -> void:
	GameState.harvest(_current_field.planted_mandrake)
	_refresh_buttons()
	_setup_records()

func _on_leave_button_button_up() -> void:
	_current_field = null
	UIManager.leave_mandrake_status()
