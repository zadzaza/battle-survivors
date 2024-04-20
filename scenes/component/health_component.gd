extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_decreased
signal health_increment(number: float)

@export var default_max_health: float = 10 # Значение по умолчанию для max_health если player_class не найден или родитель не Player

var current_health: float
var player_class

@onready var experience_manager: ExperienceManager
@onready var max_health: float = get_max_health()

func get_max_health() -> float:
	player_class = ClassManager.get_player_class()
	if check_is_player():
		return player_class.max_health
	return default_max_health

func _ready() -> void:
	current_health = max_health
	GameEvents.vial_collected.connect(on_health_increment)

func on_health_increment(number: float, vial_type: String):
	if check_is_player():
		if vial_type == "health_vial":
			heal(number)

func damage(damage_amount: float) -> void:
	current_health = clamp(current_health - damage_amount, 0, max_health)
	health_changed.emit()
	if damage_amount > 0:
		health_decreased.emit()
	Callable(check_death).call_deferred()

func heal(heal_amount):
	damage(-heal_amount)

func get_health_percent() -> float:
	if max_health <= 0: return 0
	return min(current_health / max_health, 1)

func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()

func check_is_player():
	if player_class != null and get_parent() is Player:
		return true
	else:
		return false
