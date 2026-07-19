extends CanvasLayer

signal day_closed

@onready var gui: GUI = $GUI
@onready var mandrake_status_panel: MandrakeStatusPanel = $MandrakeStatusPanel
@onready var black_overlay: ColorRect = $NextDayComponent/BlackOverlay
@onready var date_label: Label = $NextDayComponent/DateLabel
@onready var old_date_label: Label = $NextDayComponent/OldDateLabel
@onready var click_anywhere_label: Label = $NextDayComponent/ClickAnywhereLabel

var ready_next_day := false

func show_mandrake_status(mandrake: MandrakeField) -> void:
	GameState.input_enable = false
	mandrake_status_panel.setup_panel(mandrake)
	
	gui.hide()
	mandrake_status_panel.show()

func leave_mandrake_status() -> void:
	GameState.input_enable = true
	
	mandrake_status_panel.hide()
	gui.show()
	
func close_the_day(today_date: String, tomorrow_date: String) -> void:
	var overlay_tween := create_tween()
	overlay_tween.tween_property(black_overlay, "modulate:a", 1.0, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	overlay_tween.tween_interval(0.5)
	await overlay_tween.finished
	day_closed.emit()
	await _animate_date_roll(today_date, tomorrow_date)
	
	ready_next_day = true
	
func _animate_date_roll(today_date: String, tomorrow_date: String) -> void:
	var offset := 40.0
	var original_pos := date_label.position

	old_date_label.position = original_pos
	old_date_label.text = today_date
	old_date_label.modulate.a = 1.0

	date_label.text = tomorrow_date
	date_label.position.y = original_pos.y + offset
	date_label.modulate.a = 0.0

	var tween := create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(
		old_date_label, 
		"position:y", 
		original_pos.y - offset, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(
		old_date_label, 
		"modulate:a", 
		0.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	tween.tween_property(
		date_label, 
		"position:y", 
		original_pos.y, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		date_label, 
		"modulate:a", 
		1.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.set_parallel(false)
	
	tween.tween_interval(1.0)
	tween.tween_property(
		click_anywhere_label, 
		"modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await tween.finished

func open_the_day() -> void:
	var tween := create_tween()
	tween.tween_property(
		date_label, 
		"modulate:a", 
		0.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(
		click_anywhere_label, 
		"modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		black_overlay, 
		"modulate:a", 0.0, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	ready_next_day = false
	
func _input(event: InputEvent) -> void:
	if not ready_next_day: return
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				open_the_day()
