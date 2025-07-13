extends Node

signal health_changed(current: float, max_hp: float)
signal player_died
signal stat_changed

var max_health: float : set = _set_max_hp
var current_health: float : set = _set_current_health
var attack_damage: float
var crit_chance: float
var attack_speed: float : set = _set_attack_speed
var life_steal: float
var defense: float
var spell_power: float
var mana_regen: float : set = _set_mana_regen
var spell_unlocked := false


func _ready() -> void:
	current_health = max_health
	CombatEvents.new_game_started.connect(_on_new_game_started)


func _set_max_hp(value: float) -> void:
	max_health = value
	health_changed.emit(current_health, max_health)


func _set_current_health(value: float) -> void:
	current_health = clampf(value, -1, max_health)
	health_changed.emit(current_health, max_health)
	if current_health <= 0:
		player_died.emit()


func _set_attack_speed(value: float) -> void:
	attack_speed = value
	stat_changed.emit()


func _set_mana_regen(value: float) -> void:
	mana_regen = value
	stat_changed.emit()


func _on_new_game_started() -> void:
	max_health = 20
	current_health = max_health
	attack_damage = 5
	crit_chance = 0
	attack_speed = 1
	life_steal = 0
	defense = 0
	spell_power = 0
	mana_regen = 1
	spell_unlocked = false
