extends Node
class_name HealthManager

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

const TARGET_EXPERIENCE_GROWTH = 5

var current_health: float

@onready var health_component: HealthComponent

func _ready():
	GameEvents.healing_vial_collected.connect(on_healing_vial_collected)
	
func increment_health(number: float):
	if health_component.check_is_player():
		health_component.current_health += 1
		
func on_healing_vial_collected(number: float):
	increment_health(number)
