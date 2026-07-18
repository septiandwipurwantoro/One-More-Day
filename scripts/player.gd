extends CharacterBody2D
class_name Player

@export var max_speed: float = 300.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_root: Node2D = $InteractionRoot

var interactable: Interactable
var facing_direction: Vector2

func _ready() -> void:
	facing_direction = Vector2.RIGHT
	_update_face_direction(facing_direction)

func _physics_process(_delta: float) -> void:
	var input_dir := _get_input_direction()

	if input_dir != Vector2.ZERO:
		velocity = input_dir * max_speed
	else:
		velocity = Vector2.ZERO

	_update_face_direction(input_dir)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if interactable: interactable.interact(self)

func _update_face_direction(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		sprite.play("idle")
		return
	
	sprite.play("run")
	match direction:
		Vector2.LEFT:
			facing_direction = Vector2.LEFT
			sprite.flip_h = false
		Vector2.RIGHT:
			facing_direction = Vector2.RIGHT
			sprite.flip_h = true
			
	interaction_root.rotation = facing_direction.angle()

func _get_input_direction() -> Vector2: 
	var raw := Vector2( Input.get_axis("move_left", "move_right"), 
	Input.get_axis("move_up", "move_down") ) 
	if raw == Vector2.ZERO: return Vector2.ZERO 
	if absf(raw.x) > absf(raw.y): return Vector2(sign(raw.x), 0) 
	else: return Vector2(0, sign(raw.y))

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area is Interactable and interactable == null: interactable = area

func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area is Interactable and interactable: interactable = null
