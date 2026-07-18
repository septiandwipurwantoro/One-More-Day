extends CharacterBody2D
class_name Player

@export var max_speed: float = 250.0
@export var acceleration: float = 2000.0
@export var friction: float = 2500.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_root: Node2D = $InteractionRoot

var interactable: Interactable
var facing_direction: Vector2

func _ready() -> void:
	facing_direction = Vector2.DOWN
	_update_face_direction(facing_direction)

func _physics_process(delta: float) -> void:
	var input_dir := _get_input_direction()
	var target_velocity := input_dir * max_speed

	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	_update_face_direction(input_dir)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if interactable: interactable.interact(self)

func _update_face_direction(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		match facing_direction:
			Vector2.UP:
				sprite.play("idle_up")
			Vector2.DOWN:
				sprite.play("idle_down")
			Vector2.RIGHT, Vector2.LEFT:
				sprite.play("idle_side")
		return

	match direction:
		Vector2.UP:
			facing_direction = Vector2.UP
			sprite.play("run_up")
		Vector2.LEFT:
			facing_direction = Vector2.LEFT
			sprite.play("run_side")
			sprite.flip_h = true
		Vector2.RIGHT:
			facing_direction = Vector2.RIGHT
			sprite.play("run_side")
			sprite.flip_h = false
		Vector2.DOWN:
			facing_direction = Vector2.DOWN
			sprite.play("run_down")
			
	interaction_root.rotation = facing_direction.angle()

func _get_input_direction() -> Vector2:
	var raw := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if raw == Vector2.ZERO:
		return Vector2.ZERO

	if absf(raw.x) > absf(raw.y):
		return Vector2(sign(raw.x), 0)
	else:
		return Vector2(0, sign(raw.y))

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area is Interactable and interactable == null: interactable = area

func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area is Interactable and interactable: interactable = null
