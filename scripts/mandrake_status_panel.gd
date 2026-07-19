extends Control
class_name MandrakeStatusPanel

@export var mandrake_record_scene: PackedScene

@onready var plant_button: Button = %PlantButton
@onready var water_button: Button = %WaterButton
@onready var use_potion_button: Button = %UsePotionButton
@onready var harvest_button: Button = %HarvestButton
@onready var leave_button: Button = %LeaveButton

@onready var mandrake_sprite: AnimatedSprite2D = %MandrakeSprite

@onready var records_scroller: ScrollContainer = %RecordsScroller
@onready var mandrake_records: VBoxContainer = %MandrakeRecords

var current_inspector: Player
var current_field: MandrakeField

func setup_panel(inspector: Player, field: MandrakeField) -> void:
	current_inspector = inspector
	current_field = field
	
	_setup_records()
	_setup_mandrake_maturity()
	_refresh_buttons()

func _setup_records() -> void:
	_remove_all_records()
	var mandrake: Mandrake = current_field.planted_mandrake
	if mandrake:
		var records := mandrake.records
		if records:
			var last_racord: MandrakeRecord
			for record in records:
				var mandrake_record: MandrakeRecord = mandrake_record_scene.instantiate()
				mandrake_records.add_child(mandrake_record)
				mandrake_record.setup(record)
				last_racord = mandrake_record
				
			await get_tree().process_frame
			records_scroller.ensure_control_visible(last_racord)
			return

func _setup_mandrake_maturity() -> void:
	mandrake_sprite.show()
	var mandrake: Mandrake = current_field.planted_mandrake
	if mandrake:
		match mandrake.current_state:
			Mandrake.Maturity.SEED:
				mandrake_sprite.play("seed")
			Mandrake.Maturity.SPROUT:
				mandrake_sprite.play("sprout")
			Mandrake.Maturity.YOUNG:
				mandrake_sprite.play("young")
			Mandrake.Maturity.MATURE:
				mandrake_sprite.play("mature")
		
		return
		
	mandrake_sprite.hide()
		
func _remove_all_records() -> void:
	for record in mandrake_records.get_children():
		record.queue_free() 

func _refresh_buttons() -> void:
	var mandrake: Mandrake = current_field.planted_mandrake

	_hide_all_buttons()
	_enable_all_button()

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

func _enable_all_button() -> void:
	plant_button.disabled = false
	water_button.disabled = false
	use_potion_button.disabled = false
	harvest_button.disabled = false
	leave_button.disabled = false

func _disable_all_buttons() -> void:
	plant_button.disabled = true
	water_button.disabled = true
	use_potion_button.disabled = true
	harvest_button.disabled = true
	leave_button.disabled = true
		
func _on_plant_button_button_up() -> void:
	_disable_all_buttons()
	await current_inspector.play_interaction()
	current_field.plant()
	_setup_records()
	_setup_mandrake_maturity()
	_refresh_buttons()

func _on_water_button_button_up() -> void:
	if not Inventory.has_water():
		UIManager.make_notification("You have no water")
		return
	
	_disable_all_buttons()
	await current_inspector.play_watering()
	current_field.planted_mandrake.water_mandrake()
	_setup_records()
	_setup_mandrake_maturity()
	_refresh_buttons()

func _on_use_potion_button_button_up() -> void:
	if not Inventory.has_potion():
		UIManager.make_notification("You have no potion")
		return
	
	_disable_all_buttons()
	await current_inspector.play_watering()
	current_field.planted_mandrake.potion_mandrake()
	_setup_records()
	_setup_mandrake_maturity()
	_refresh_buttons()

func _on_harvest_button_button_up() -> void:
	_disable_all_buttons()
	
	await UIManager.blink(0.0, 0.1)
	await UIManager.open_blink()
	await get_tree().create_timer(0.5).timeout
	
	await UIManager.blink()
	mandrake_sprite.play("pulled")
	await UIManager.open_blink()
	await get_tree().create_timer(1.5).timeout
	
	mandrake_sprite.play("scream")
	await mandrake_sprite.animation_finished
	await get_tree().create_timer(3.0).timeout

	GameState.harvest(current_field.planted_mandrake, current_inspector)
	
	current_field = null
	UIManager.leave_mandrake_status()

func _on_leave_button_button_up() -> void:
	current_field = null
	UIManager.leave_mandrake_status()
