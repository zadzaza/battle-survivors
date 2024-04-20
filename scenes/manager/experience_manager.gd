extends Node
class_name ExperienceManager

signal experience_updated(current_experience: float, target_experience: float)
signal health_increment(increment_count: float)
signal level_up(new_level: int)

var health_component: HealthComponent

const TARGET_EXPERIENCE_GROWTH = 5

var current_experience = 0
var current_level = 1
var target_experience = 1

var increment_count = 1

func _ready():
	GameEvents.vial_collected.connect(on_vial_collected)
	
func increment_vial(number: float, vial_type: String):
	if vial_type == "experience_vial":
		current_experience = min(current_experience + number, target_experience)
		experience_updated.emit(current_experience, target_experience)
	
		if current_experience == target_experience:
			current_level += 1
			target_experience += TARGET_EXPERIENCE_GROWTH
			current_experience = 0
			experience_updated.emit(current_experience, target_experience)
			level_up.emit(current_level)

func on_vial_collected(number: float, vial_type: String):
	increment_vial(number, vial_type)
