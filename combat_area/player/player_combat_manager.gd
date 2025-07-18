class_name PlayerCombatManager
extends Node

var attack_damage_dict: Dictionary[int, float] = {
	0: 10, # level 0 and level 1 should have the same value
	1: 10, # level 0 and level 1 should have the same value
	2: 11.5,
	3: 13,
	4: 14.5,
	5: 16,
	6: 17.5,
	7: 19,
	8: 21.5,
	9: 24,
	10: 25.5,
	11: 28
}
var attack_speed_dict: Dictionary[int, float] = {
	0: 1, # level 0 and level 1 should have the same value
	1: 1, # level 0 and level 1 should have the same value
	2: 1.4,
	3: 1.8,
	4: 2.2,
	5: 2.6,
	6: 2.9,
	7: 3.2,
	8: 3.5,
	9: 3.8,
	10: 4,
	11: 4.2
}
var crit_chance_dict: Dictionary[int, float] = {
	0: 0.05,
	1: 0.1,
	2: 0.15,
	3: 0.2,
	4: 0.25,
	5: 0.3,
	6: 0.35,
	7: 0.40,
	8: 0.45,
	9: 0.50,
	10: 0.55,
	11: 0.60
}
var lifesteal_dict: Dictionary[int, float] = {
	0: 0,
	1: 0.20,
	2: 0.40,
	3: 0.60,
	4: 0.80,
	5: 1.0,
}
var spell_power_dict: Dictionary[int, float] = {
	0: 0,
	1: 2,
	2: 4,
	3: 6,
	4: 8,
	5: 10,
	6: 12,
	7: 14,
	8: 16,
	9: 18,
	10: 20,
	11: 22
}
var mana_regen_dict: Dictionary[int, float] = {
	0: 0,
	1: 0.5,
	2: 1,
	3: 1.5,
	4: 2,
	5: 2.5,
	6: 3,
	7: 3.5,
	8: 4,
	9: 4.5,
	10: 5,
	11: 5.5
}
@export var attack_damage: Upgrade
@export var attack_speed: Upgrade
@export var crit_chance: Upgrade
@export var lifesteal: Upgrade
@export var spell_power: Upgrade
@export var mana_regen: Upgrade

@onready var combat_text_maker: CombatTextMaker = %CombatTextMaker
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
		var damage := attack_damage_dict[attack_damage.level]
		combat_text_maker.make_text(damage, e.global_position - Vector2(0, 45), false, CombatTextMaker.Type.DAMAGE)
		e.stats.current_health -= damage
		mana_progress.value = 0


func attack() -> void:
	for e: Enemy in enemy_manager.enemies:
		if not is_instance_valid(e) or e.dying:
			continue
		var damage := attack_damage_dict[attack_damage.level]
		var crit := randf() < crit_chance_dict[crit_chance.level]
		if crit:
			damage *= 2
		var heal_amount := minf(e.stats.current_health, damage) * lifesteal_dict[lifesteal.level]
		if heal_amount < 1: 
			heal_amount = 1.1
		Player.current_health += heal_amount
		e.stats.current_health -= damage
		combat_text_maker.make_text(damage, e.global_position - Vector2(0, 45), crit, CombatTextMaker.Type.DAMAGE)
		attack_progress.value = 0
		break


func die() -> void:
	CombatEvents.game_over.emit(false)


func _on_health_changed(current: float, max_hp: float) -> void:
	var difference := health_progress.value - current
	# Player healing text
	if difference < -1:
		combat_text_maker.make_text(abs(difference), player_sprite.global_position + Vector2(-10, 5), false, CombatTextMaker.Type.HEALING)
	# Player damage text
	if difference > 1:
		combat_text_maker.make_text(abs(difference), player_sprite.global_position + Vector2(-10, 5), false, CombatTextMaker.Type.DAMAGE)
	health_progress.value = current
	health_progress.max_value = max_hp


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "death" or anim_name == "idle":
		return
	player_animator.play("idle")


func _on_player_died() -> void:
	player_animator.play("death")
