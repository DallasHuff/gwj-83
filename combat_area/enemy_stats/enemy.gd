class_name Enemy
extends Node2D

signal attacked
signal died

var stats: EnemyStats : set = _set_stats
var in_combat := false
var dying := false

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var attack_progress: ProgressBar = %AttackProgress
@onready var health_progress: ProgressBar = %HealthProgress


func _process(delta: float) -> void:
	if not in_combat:
		return
	attack_progress.value += delta

	if animation_player.is_playing():
		return

	if attack_progress.value >= attack_progress.max_value:
		animation_player.play("attack")


func _set_stats(value: EnemyStats) -> void:
	if not is_node_ready():
		await ready

	if not value:
		push_error("no stats")
		return

	stats = value.duplicate()
	stats.current_health = stats.health
	attack_progress.max_value = stats.time_between_attacks
	_on_stats_changed()
	sprite.sprite_frames = stats.sprite_frames
	stats.changed.connect(_on_stats_changed)


func attack() -> void:
	attack_progress.value = 0
	attacked.emit()


func die() -> void:
	CombatEvents.enemy_died.emit(stats)
	died.emit()


func _on_stats_changed() -> void:
	health_progress.max_value = stats.health
	health_progress.value = stats.current_health
	if stats.current_health <= 0:
		dying = true
		animation_player.play("death")
