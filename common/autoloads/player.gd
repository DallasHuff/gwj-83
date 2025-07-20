extends Node

signal health_changed(current: float, max_hp: float)
signal player_died

# Dictionaries are [level, value]
var max_health_dict: Dictionary[int, float] = {
	0: 100, # level 0 and level 1 should have the same value
	1: 100, # level 0 and level 1 should have the same value
	2: 120,
	3: 140,
	4: 160,
	5: 180,
	6: 200,
	7: 220,
	8: 240,
	9: 260,
	10: 280,
	11: 300
}
# This is % of damage to be taken. so 1 is 100%, 0.9 is 90% damage taken (10% reduction)
var defense_dict: Dictionary[int, float] = {
	0: 1,
	1: 0.97,
	2: 0.93,
	3: 0.91,
	4: 0.88,
	5: 0.85,
	6: 0.82,
	7: 0.79,
	8: 0.76,
	9: 0.73,
	10: 0.70,
	11: 0.67
}
var max_health: Upgrade = preload("res://shop/upgrades/health.tres") : set = _set_max_hp
var defense: Upgrade = preload("res://shop/upgrades/defense.tres")
var current_health: float : set = _set_current_health


func _ready() -> void:
	CombatEvents.new_game_started.connect(_on_new_game_started)


func _set_max_hp(value: Upgrade) -> void:
	max_health = value
	current_health = max_health_dict[1]
	max_health.level_changed.connect(_on_max_health_changed)
	health_changed.emit(current_health, current_health)


func _set_current_health(value: float) -> void:
	current_health = clampf(value, -1, max_health_dict[max_health.level])
	health_changed.emit(current_health, max_health_dict[max_health.level])
	if current_health <= 0:
		player_died.emit()


func _on_max_health_changed() -> void:
	var difference := max_health_dict[max_health.level-1] - current_health
	current_health = max_health_dict[max_health.level] - difference
	health_changed.emit(current_health, max_health_dict[max_health.level])


func _on_new_game_started() -> void:
	current_health = max_health_dict[1]
	health_changed.emit(current_health, current_health)
