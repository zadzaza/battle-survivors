extends Node

signal vial_collected(number, vial_type)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged

func emit_vial_collected(number: float, vial_type: String) -> void:
	vial_collected.emit(number, vial_type)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	ability_upgrade_added.emit(upgrade, current_upgrades)

func emit_player_damaged():
	player_damaged.emit()
