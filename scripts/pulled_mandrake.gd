extends AnimatedSprite2D
class_name PulledMandrake

var following_mandrake: Mandrake
var followed_harvester: Player

var follow_distance_min: float = 30.0
var follow_distance_max: float = 55.0
var smooth_speed: float = 5.0
var bobbing_amplitude: float = 6.0
var bobbing_speed: float = 3.0

var time_passed: float = 0.0

var screaming := false
var scream_duration := 3.0
var scream_cooldown := 5.0
var scream_duration_timer := 0.0
var scream_cooldown_timer := 0.0

func setup(harvester: Player, mandrake: Mandrake) -> void:
	following_mandrake = mandrake
	followed_harvester = harvester

	var angle := randf() * TAU
	var dist := randf_range(follow_distance_min, follow_distance_max)
	offset = Vector2(cos(angle), sin(angle)) * dist

	smooth_speed = randf_range(4.0, 6.5)
	bobbing_speed = randf_range(2.5, 3.5)
	time_passed = randf_range(0.0, TAU)

	global_position = followed_harvester.global_position + offset
	scream_cooldown_timer = randf_range(scream_cooldown, scream_cooldown * 1.5)

func _process(delta: float) -> void:
	if not followed_harvester: return

	if screaming:
		scream_duration_timer -= delta
		if scream_duration_timer <= 0:
			play("idle")
			scream_cooldown_timer = randf_range(scream_cooldown, scream_cooldown * 1.5)
			screaming = false
	else:
		scream_cooldown_timer -= delta
		if scream_cooldown_timer <= 0:
			play("scream")
			scream_duration_timer = scream_duration
			screaming = true

	time_passed += delta

	var desired_pos := followed_harvester.global_position + offset

	var bobbing := Vector2(
		sin(time_passed * bobbing_speed) * bobbing_amplitude * 0.4,
		sin(time_passed * bobbing_speed * 1.3) * bobbing_amplitude)

	desired_pos += bobbing

	global_position = global_position.lerp(desired_pos, smooth_speed * delta)
