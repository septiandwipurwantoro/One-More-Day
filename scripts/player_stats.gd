extends Node

signal health_changed(amount: float)

const MAX_HEALTH := 100.0

@onready var health := MAX_HEALTH

func take_damange(damage: float) -> void:
	health -= damage
	health_changed.emit(health)
