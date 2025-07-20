class_name PlayerCombatManager
extends Node

var attack_damage_dict: Dictionary[int, float] = {
	0: 10, # level 0 and level 1 should have the same value
	1: 10, # level 0 and level 1 should have the same value
	2: 13,
	3: 16,
	4: 19,
	5: 22,
	6: 25,
	7: 28,
	8: 31,
	9: 34,
	10: 37,
	11: 40
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
	0: 10,
	1: 14,
	2: 18,
	3: 22,
	4: 26,
	5: 30,
	6: 34,
	7: 38,
	8: 42,
	9: 46,
	10: 50,
	11: 54
}
var mana_regen_dict: Dictionary[int, float] = {
	0: 0,
	1: 1,
	2: 2,
	3: 3,
	4: 4,
	5: 5
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
	CombatEvents.mana_clicked.connect(func()->void:mana_progress.value += 1)


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


func consume() -> void:
	if player_animator.current_animation == "idle":
		player_sprite.play("consume")


func target_available() -> bool:
	for e: Enemy in enemy_manager.enemies:
		if is_instance_valid(e) and not e.dying:
			return true
	return false


func cast() -> void:
	for e: Enemy in enemy_manager.enemies:
		if not is_instance_valid(e) or e.dying:
			continue
		var damage := spell_power_dict[spell_power.level]
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
