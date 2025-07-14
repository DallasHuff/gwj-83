class_name PlayerCombatManager
extends Node

var attack_damage_dict: Dictionary[int, float] = {
	0: 5, # level 0 and level 1 should have the same value
	1: 5, # level 0 and level 1 should have the same value
}
var attack_speed_dict: Dictionary[int, int] = {
	0: 1, # level 0 and level 1 should have the same value
	1: 1, # level 0 and level 1 should have the same value
}
var crit_chance_dict: Dictionary[int, float] = {
	0: 0,
	1: 10,
}
var lifesteal_dict: Dictionary[int, float] = {
	0: 0,
}
var spell_power_dict: Dictionary[int, float] = {
	0: 0,
}
var mana_regen_dict: Dictionary[int, float] = {
	0: 0,
}
@export var attack_damage: Upgrade
@export var attack_speed: Upgrade
@export var crit_chance: Upgrade
@export var lifesteal: Upgrade
@export var spell_power: Upgrade
@export var mana_regen: Upgrade

@onready var player_animator: AnimationPlayer = %PlayerAnimator
@onready var player_sprite: AnimatedSprite2D = %PlayerSprite
@onready var health_progress: ProgressBar = %HealthProgress
@onready var attack_progress: ProgressBar = %AttackProgress
@onready var mana_progress: ProgressBar = %ManaProgress
@onready var enemy_manager: EnemyManager = %EnemyManager


func _ready() -> void:
	Player.player_died.connect(_on_player_died)
	Player.health_changed.connect(_on_health_changed)
	player_animator.animation_finished.connect(_on_animation_finished)


func _process(delta: float) -> void:
	attack_progress.value += delta * attack_speed_dict[attack_speed.level]
	mana_progress.value += delta * mana_regen_dict[mana_regen.level]
	if player_animator.is_playing():
		return
	if attack_progress.value >= attack_progress.max_value:
		if target_available():
			player_animator.play("attack")
		return
	if mana_progress.value >= mana_progress.max_value:
		if target_available():
			player_animator.play("cast")
		return


func target_available() -> bool:
	for e: Enemy in enemy_manager.enemies:
		if is_instance_valid(e) and not e.dying:
			return true
	return false


func cast() -> void:
	for e: Enemy in enemy_manager.enemies:
		if not is_instance_valid(e) or e.dying:
			continue
		e.stats.current_health -= attack_damage_dict[attack_damage.level]
		mana_progress.value = 0


func attack() -> void:
	for e: Enemy in enemy_manager.enemies:
		if not is_instance_valid(e) or e.dying:
			continue
		var damage := attack_damage_dict[attack_damage.level]
		var heal_amount := minf(e.stats.current_health, damage) * lifesteal_dict[lifesteal.level]
		Player.current_health += heal_amount
		e.stats.current_health -= damage
		attack_progress.value = 0


func die() -> void:
	CombatEvents.game_over.emit()


func _on_health_changed(current: float, max_hp: float) -> void:
	health_progress.value = current
	health_progress.max_value = max_hp


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "death" or anim_name == "idle":
		return
	player_animator.play("idle")


func _on_player_died() -> void:
	player_animator.play("death")
