extends CanvasLayer
signal transition_finished

@onready var overlay: ColorRect = $Overlay

const FADE_DURATION := 0.3

func _ready() -> void:
	overlay.color.a = 0.0
	overlay.hide()

func change_scene(scene: String):
	await _fade_in()
	get_tree().change_scene_to_file(scene)
	await _fade_out()
	transition_finished.emit()

func reload_current_scene():
	await _fade_in()
	get_tree().reload_current_scene()
	await _fade_out()
	transition_finished.emit()

func _fade_in() -> void:
	overlay.show()
	var tween := create_tween()
	tween.tween_property(overlay, "color:a", 1.0, FADE_DURATION)
	await tween.finished

func _fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(overlay, "color:a", 0.0, FADE_DURATION)
	await tween.finished
	overlay.hide()
