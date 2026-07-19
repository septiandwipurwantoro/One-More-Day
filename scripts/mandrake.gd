extends Resource
class_name Mandrake

signal maturity_changed(new_state: Maturity)
signal mood_changed(new_mood: Mood)
signal record_added(record: Dictionary)

enum Maturity {
	NONE,
	SEED,
	SPROUT,
	YOUNG,
	MATURE
}
enum Mood {
	NEUTRAL,
	BAD,
	GOOD
}

var records: Array[Dictionary] = []

#region constants
const GROWTH_THRESHOLDS := {
	Maturity.SEED: 0.0,
	Maturity.SPROUT: 25.0,
	Maturity.YOUNG: 60.0,
	Maturity.MATURE: 100.0,
}

const GROWTH_RATE_RANGE := Vector2(110.8, 111.5)
const ROOT_STRENGTH_RANGE := Vector2(0.8, 1.4)

const DAILY_BASE_GROWTH := 3.0
const WATER_BONUS_GROWTH := 4.0
const POTION_BONUS_GROWTH := 2.0

const WATER_HEALTH_RECOVERY := 0.08
const DAILY_HEALTH_DECAY := 0.06

const AGITATION_DAILY_GAIN := 0.04
const POTION_CALM_AMOUNT := 0.5
const AGITATION_BAD_THRESHOLD := 0.7
const AGITATION_GOOD_THRESHOLD := 0.25

const POTION_PROFIT_PENALTY := 0.12
const MAX_PROFIT_PENALTY := 0.6

const BASE_WEIGHT := 0.5
const WEIGHT_GROWTH_SCALE := 0.1
const MAX_WEIGHT_MULTIPLIER := 2.0

const POWER_GROWTH_SCALE := 0.02
const BASE_SCREAM_POWER := 0.5

const COLOR_VARIANCE := 0.08
const BASE_PRICE := 10.0
const MAX_RISK_PRICE_MULTIPLIER := 2.5

const MOOD_SCREAM_MULTIPLIER := {
	Mood.GOOD: 0.8,
	Mood.NEUTRAL: 1.0,
	Mood.BAD: 1.8,
}

const HEALTH_GOOD_THRESHOLD := 0.7
const HEALTH_OKAY_THRESHOLD := 0.35

const ROOT_HEALTH_PHRASES := {
	"good": [
		"Its roots are healthy, and its breath is steady.",
		"Its roots are strong, and its breathing is calm.",
		"Its roots are firmly anchored in the soil.",
		"It breathes with quiet confidence.",
		"Its roots spread deep and without blemish.",
		"The roots pulse with quiet vitality.",
		"It shows no sign of physical distress.",
		"Its breathing is slow and even.",
	],
	
	"okay": [
		"Its roots are fairly healthy, though a little fragile at the tips.",
		"Its breathing falters slightly, but it still endures.",
		"A few roots seem brittle, but most remain intact.",
		"It breathes unevenly from time to time.",
		"Its roots have minor damage, though nothing severe.",
		"It appears somewhat tired, but still stable.",
		"Its breathing is a little shallow.",
		"The roots seem to be recovering on their own.",
	],
	
	"weak": [
		"Its roots are frail, and its breathing comes in strained gasps.",
		"Its roots have begun to wither, and its breath grows faint.",
		"Its roots are barely holding together.",
		"It struggles to draw each breath.",
		"Much of its root system has decayed.",
		"Its breathing is weak and irregular.",
		"It looks as though it could collapse at any moment.",
		"The roots are dry, brittle, and close to failing.",
	],
}

const MOOD_STATUS_PHRASES := {
	Mood.GOOD: [
		"It seems calm and composed.",
		"It looks at peace.",
		"It sways gently, without resistance.",
		"It appears content with its surroundings.",
		"It remains remarkably relaxed.",
		"It barely reacts to your presence.",
		"Its movements are slow and gentle.",
		"It seems unusually cooperative.",
	],
	
	Mood.NEUTRAL: [
		"It seems stable.",
		"It appears ordinary.",
		"It quietly watches its surroundings.",
		"It shows little emotion.",
		"It neither welcomes nor rejects your presence.",
		"It appears alert, but unconcerned.",
		"It waits without making a sound.",
		"Its behavior is difficult to read.",
	],
	
	Mood.BAD: [
		"It seems restless and easily agitated.",
		"It looks angry, struggling ever so slightly.",
		"It twists uneasily beneath the soil.",
		"It recoils at the slightest movement.",
		"It trembles with visible irritation.",
		"It watches you with quiet hostility.",
		"Its breathing grows sharper as you approach.",
		"It seems ready to lash out at any moment.",
	],
}

#endregion

#region states
var current_state: Maturity = Maturity.SEED
var cared_today := false

#endregion

#region variant
var weight := BASE_WEIGHT
var current_color := Color.ORANGE

#endregion

#region adjustment and potential
var growth_rate := 1.0
var root_strength := 1.0

#endregion

#region status
var health := 1.0
var growth := 0.0
var agitation := 0.0
var mood: Mood = Mood.NEUTRAL
var scream_power := 0.0
var profit_penalty := 0.0

#endregion

#region lifecycle
func create() -> void:
	current_state = Maturity.NONE
	cared_today = false
	weight = BASE_WEIGHT
	current_color = Color.ORANGE
	growth_rate = randf_range(GROWTH_RATE_RANGE.x, GROWTH_RATE_RANGE.y)
	root_strength = randf_range(ROOT_STRENGTH_RANGE.x, ROOT_STRENGTH_RANGE.y)
	health = 1.0
	growth = 0.0
	agitation = 0.0
	mood = Mood.NEUTRAL
	scream_power = BASE_SCREAM_POWER + root_strength
	profit_penalty = 0.0
	records.clear()
	_update_maturity()
	add_record("Mandrake is planted")

func advance_day() -> void:
	if not cared_today: health = clampf(health - DAILY_HEALTH_DECAY, 0.0, 1.0)
		
	growth += DAILY_BASE_GROWTH * growth_rate
	agitation = clampf(agitation + AGITATION_DAILY_GAIN, 0.0, 1.0)
	cared_today = false

	_update_maturity()
	_recalculate_derived_stats()
	_update_mood()
	add_record(_build_daily_status_text())
	
#endregion

#region records handling
func add_record(text: String) -> void:
	var entry := {
		"date": GameState.get_current_date(),
		"record": text,
	}
	
	records.append(entry)
	record_added.emit(entry)

func _build_daily_status_text() -> String:
	var health_tier := "weak"
	if health >= HEALTH_GOOD_THRESHOLD:
		health_tier = "good"
	elif health >= HEALTH_OKAY_THRESHOLD:
		health_tier = "okay"

	var root_options: Array = ROOT_HEALTH_PHRASES[health_tier]
	var mood_options: Array = MOOD_STATUS_PHRASES[mood]
	var root_phrase: String = root_options[randi() % root_options.size()]
	var mood_phrase: String = mood_options[randi() % mood_options.size()]
	return "%s %s Weighs %.2f kg." % [root_phrase, mood_phrase, weight]
	
#endregion

#region growth logic
func _recalculate_derived_stats() -> void:
	weight = BASE_WEIGHT + WEIGHT_GROWTH_SCALE * sqrt(growth)
	scream_power = BASE_SCREAM_POWER + root_strength + POWER_GROWTH_SCALE * growth

func _update_maturity() -> void:
	var new_state := current_state
	for state in [Maturity.MATURE, Maturity.YOUNG, Maturity.SPROUT, Maturity.SEED]:
		if growth >= GROWTH_THRESHOLDS[state]:
			new_state = state
			break
			
	if new_state != current_state:
		current_state = new_state
		maturity_changed.emit(current_state)
		if new_state == Maturity.SEED: return
		add_record("Mandrake grew into %s stage" % Maturity.keys()[current_state])

func _update_mood() -> void:
	var new_mood: Mood = Mood.NEUTRAL
	if agitation >= AGITATION_BAD_THRESHOLD:
		new_mood = Mood.BAD
	elif agitation <= AGITATION_GOOD_THRESHOLD:
		new_mood = Mood.GOOD
		
	if new_mood != mood:
		mood = new_mood
		mood_changed.emit(mood)
		
#endregion

#region actions
func water_mandrake() -> void:
	Inventory.use_water()
	
	growth += WATER_BONUS_GROWTH * growth_rate
	health = clampf(health + WATER_HEALTH_RECOVERY, 0.0, 1.0)
	cared_today = true
	
	add_record("Mandrake was watered")
	_update_maturity()
	_recalculate_derived_stats()
	_update_mood()

func potion_mandrake() -> void:
	Inventory.use_potion()
	
	growth += POTION_BONUS_GROWTH * growth_rate
	agitation = clampf(agitation - POTION_CALM_AMOUNT, 0.0, 1.0)
	profit_penalty = clampf(profit_penalty + POTION_PROFIT_PENALTY, 0.0, MAX_PROFIT_PENALTY)
	cared_today = true
	
	add_record("Mandrake was given a potion")
	adjust_to_near_random_color()
	_update_maturity()
	_recalculate_derived_stats()
	_update_mood()

func adjust_to_near_random_color() -> void:
	var h := current_color.h + randf_range(-COLOR_VARIANCE, COLOR_VARIANCE)
	var s := clampf(current_color.s + randf_range(-COLOR_VARIANCE, COLOR_VARIANCE), 0.0, 1.0)
	var v := clampf(current_color.v + randf_range(-COLOR_VARIANCE, COLOR_VARIANCE), 0.0, 1.0)
	current_color = Color.from_hsv(fposmod(h, 1.0), s, v)
	
#endregion

#region getters
func _get_weight_multiplier() -> float:
	var weight_ratio := weight / BASE_WEIGHT
	return lerpf(1.0, MAX_WEIGHT_MULTIPLIER, clampf(weight_ratio - 1.0, 0.0, 1.0))

func get_scream_damage() -> float:
	var health_multiplier := lerpf(0.3, 1.5, health)
	var mood_multiplier: float = MOOD_SCREAM_MULTIPLIER[mood]
	var weight_multiplier := _get_weight_multiplier()
	return scream_power * health_multiplier * mood_multiplier * weight_multiplier

func get_variant_name() -> String:
	var mood_prefix := ""
	match mood:
		Mood.GOOD:
			mood_prefix = "Radiant "
		Mood.BAD:
			mood_prefix = "Enraged "
			
	return "%s%s Mandrake" % [mood_prefix, Maturity.keys()[current_state].capitalize()]

func get_price() -> int:
	var maturity_multiplier := 1.0 + int(current_state) * 0.75
	var health_multiplier := lerpf(0.5, 1.5, health)
	var risk_multiplier := lerpf(1.0, MAX_RISK_PRICE_MULTIPLIER, agitation)
	var weight_multiplier := _get_weight_multiplier()
	var profit_multiplier := 1.0 - profit_penalty

	return int(round(
		BASE_PRICE
		* maturity_multiplier
		* health_multiplier
		* risk_multiplier
		* weight_multiplier
		* profit_multiplier
	))
	
#endregion
