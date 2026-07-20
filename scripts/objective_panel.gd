extends PanelContainer

@onready var objective_label: RichTextLabel = %ObjectiveLabel

var offscreen_x: float
var onscreen_x: float

var objective_tween: Tween

func _ready() -> void:
	offscreen_x = position.x
	onscreen_x = offscreen_x + size.x + 32
	
	GameState.objective_set_up.connect(_on_objective_set_up)
	GameState.objective_completed.connect(_on_objective_completed)

func _on_objective_set_up(objective: Objective) -> void:
	objective_label.text = objective.get_objective_text()
	show_objective()
	
func show_objective() -> void:
	position.x = offscreen_x
	
	if objective_tween: objective_tween.kill()
	
	objective_tween = create_tween()
	objective_tween.tween_property(
		self, 
		"position:x", 
		onscreen_x, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
func _on_objective_completed() -> void: hide_objective()
func hide_objective() -> void:
	if objective_tween: objective_tween.kill()
	
	objective_tween = create_tween()
	objective_tween.tween_property(
		self, 
		"position:x", 
		offscreen_x, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
