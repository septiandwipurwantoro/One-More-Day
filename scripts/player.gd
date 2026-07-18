extends CharacterBody2D

@export var max_speed: float = 250.0
@export var acceleration: float = 2000.0
@export var friction: float = 2500.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var facing_direction := Vector2.DOWN

func _physics_process(delta: float) -> void:
	var input_dir := _get_input_direction()
	var target_velocity := input_dir * max_speed

	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	_update_face_direction(input_dir)
	move_and_slide()

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
