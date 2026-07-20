extends CharacterBody2D
class_name Player

@export var entry_point: Node2D
@export var max_speed: float = 300.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $InteractionArea
@onready var camera: Camera2D = $Camera2D

const SHAKE_STRENGTH: float = 8.0
const SHAKE_DURATION: float = 0.3
const SHAKE_COUNT: int = 6

var interactable: Interactable
var facing_direction: Vector2
var in_interaction := false

var _shake_tween: Tween

func _ready() -> void:
	facing_direction = Vector2.RIGHT
	_update_face_direction(facing_direction)
	
	GameState.day_advanced.connect(_on_day_advanced)

func _physics_process(delta: float) -> void:
	if in_interaction: return
	
	var input_dir := _get_input_direction()

	if input_dir != Vector2.ZERO:
		velocity = input_dir * max_speed
	else:
		velocity = Vector2.ZERO

	_update_face_direction(input_dir)
	move_and_collide(velocity * delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if interactable: interactable.interact(self)

func take_damage(damage: float) -> void:
	PlayerStats.take_damange(damage)
	_shake_camera()

func _shake_camera() -> void:
	if _shake_tween and _shake_tween.is_valid():
		_shake_tween.kill()

	_shake_tween = create_tween()
	var step_time := SHAKE_DURATION / SHAKE_COUNT

	for i in SHAKE_COUNT:
		var offset := Vector2(
			randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH),
			randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH)
		)
		_shake_tween.tween_property(camera, "offset", offset, step_time)

	_shake_tween.tween_property(camera, "offset", Vector2.ZERO, step_time)

func _update_face_direction(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		sprite.play("idle")
		return
	
	sprite.play("run")
	match direction:
		Vector2.LEFT:
			facing_direction = Vector2.LEFT
			sprite.flip_h = false
			interaction_area.scale.x = -1
		Vector2.RIGHT:
			facing_direction = Vector2.RIGHT
			sprite.flip_h = true
			interaction_area.scale.x = 1

func _get_input_direction() -> Vector2: 
	if not GameState.input_enable: return Vector2.ZERO
	
	var raw := Vector2( Input.get_axis("move_left", "move_right"), 
	Input.get_axis("move_up", "move_down") ) 
	if raw == Vector2.ZERO: return Vector2.ZERO 
	if absf(raw.x) > absf(raw.y): return Vector2(sign(raw.x), 0) 
	else: return Vector2(0, sign(raw.y))

func play_interaction() -> void:
	in_interaction = true
	sprite.play("interact")
	
	await sprite.animation_finished
	in_interaction = false

func play_watering() -> void:
	in_interaction = true
	sprite.play("watering")
	
	await sprite.animation_finished
	in_interaction = false

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area is Interactable and interactable == null: interactable = area

func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area is Interactable and interactable: interactable = null

func _on_day_advanced() -> void:
	global_position = entry_point.global_position
