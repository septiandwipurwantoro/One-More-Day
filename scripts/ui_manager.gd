extends CanvasLayer

signal day_closed

@onready var gui: GUI = $GUI
@onready var mandrake_status_panel: MandrakeStatusPanel = $MandrakeStatusPanel
@onready var overlay: ColorRect = $Overlay
@onready var day_ended_overlay: ColorRect = $DayEndedComponent/DayEndedOverlay
@onready var date_label: Label = $DayEndedComponent/DateLabel
@onready var old_date_label: Label = $DayEndedComponent/OldDateLabel
@onready var click_anywhere_label: Label = $DayEndedComponent/ClickAnywhereLabel
@onready var notification: PanelContainer = $Notification
@onready var notification_label: RichTextLabel = $Notification/NotificationLabel

var ready_next_day := false
var offscreen_x: float
var onscreen_x: float

var notification_tween: Tween

func _ready() -> void:
	offscreen_x = notification.position.x
	onscreen_x = offscreen_x - notification.size.x
		
func show_mandrake_status(inspector: Player, mandrake: MandrakeField) -> void:
	GameState.input_enable = false
	mandrake_status_panel.setup_panel(inspector, mandrake)
	
	gui.hide()
	mandrake_status_panel.show()
	
func leave_mandrake_status() -> void:
	GameState.input_enable = true
	
	mandrake_status_panel.hide()
	gui.show()
	
func blink(duration: float = 0.5, speed: float = 0.6):
	var overlay_tween := create_tween()
	overlay_tween.tween_property(
		overlay, 
		"modulate:a", 
		1.0, speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
	overlay_tween.tween_interval(duration)
	await overlay_tween.finished

func open_blink(duration: float = 0.3, speed: float = 0.4):
	var overlay_tween := create_tween()
	overlay_tween.tween_property(
		overlay, 
		"modulate:a", 
		0.0, speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
	overlay_tween.tween_interval(duration)
	await overlay_tween.finished

func make_notification(text: String) -> void:
	notification_label.text = text
	notification.position.x = offscreen_x
	
	if notification_tween: notification_tween.kill()
	var notification_tween := create_tween()
	notification_tween.tween_property(
		notification, 
		"position:x", 
		onscreen_x, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	notification_tween.tween_interval(5.0)
	notification_tween.tween_property(
	notification, 
	"position:x", 
	offscreen_x, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

func close_the_day(today_date: String, tomorrow_date: String) -> void:
	GameState.input_enable = false
	var overlay := create_tween()
	overlay.tween_property(
		day_ended_overlay, 
		"modulate:a", 
		1.0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	overlay.tween_interval(0.5)
	await overlay.finished
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
		day_ended_overlay, 
		"modulate:a", 0.0, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	GameState.input_enable = true
	ready_next_day = false
	
func _input(event: InputEvent) -> void:
	if not ready_next_day: return
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				open_the_day()
