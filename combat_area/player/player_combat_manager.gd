class_name PlayerCombatManager
extends Node

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
	attack_progress.value += delta * Player.attack_speed
	mana_progress.value += delta * Player.mana_regen
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
		e.stats.current_health -= Player.spell_power
		mana_progress.value = 0


func attack() -> void:
	for e: Enemy in enemy_manager.enemies:
		if not is_instance_valid(e) or e.dying:
			continue
		# var heal_amount := minf(e.stats.current_health, Player.attack_damage) * Player.life_steal
		# Player.current_health += heal_amount
		e.stats.current_health -= Player.attack_damage
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
