extends Node2D

@export var distance := 6.0
@export var duration := 0.8

func _ready() -> void:
	var tween := create_tween()
	tween.set_loops()

	tween.tween_property(
		self,
		"position:y",
		position.y - distance,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		self,
		"position:y",
		position.y,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
