extends CanvasLayer

@onready var gui: GUI = $GUI
@onready var mandrake_status_panel: MandrakeStatusPanel = $MandrakeStatusPanel

func show_mandrake_status(mandrake: Mandrake) -> void:
	gui.hide()
	mandrake_status_panel.show_panel(mandrake)
