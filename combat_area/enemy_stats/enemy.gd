class_name Enemy
extends Node2D

signal attacked
signal died

@export var projectile_scene: PackedScene
var stats: EnemyStats : set = _set_stats
var in_combat := false
var dying := false

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var attack_progress: ProgressBar = %AttackProgress
@onready var health_progress: ProgressBar = %HealthProgress
@onready var attack_sfx: AudioStreamPlayer2D = %AttackSFX
@onready var death_sfx: AudioStreamPlayer2D = %DeathSFX


func _process(delta: float) -> void:
	if not in_combat or dying:
		return
	attack_progress.value += delta

	if animation_player.is_playing():
		return

	if attack_progress.value >= attack_progress.max_value:
		animation_player.play("attack")
		attack_sfx.play()
		if stats.projectile_texture:
			var projectile: Projectile = projectile_scene.instantiate()
			Global.main.game.add_child(projectile)
			projectile.sprite.texture = stats.projectile_texture
			

func _set_stats(value: EnemyStats) -> void:
	if not is_node_ready():
		await ready

	if not value:
		push_error("no stats")
		return

	stats = value.duplicate()
	death_sfx.stream = stats.death_sfx
	stats.current_health = stats.health
	attack_progress.max_value = stats.time_between_attacks
	_on_stats_changed()
	sprite.sprite_frames = stats.sprite_frames
	stats.changed.connect(_on_stats_changed)


func attack() -> void:
	attack_progress.value = 0
	attacked.emit()


func die() -> void:
	CombatEvents.enemy_died.emit(self)
	died.emit()


func _on_stats_changed() -> void:
	health_progress.max_value = stats.health
	health_progress.value = stats.current_health
	if stats.current_health <= 0:
		dying = true
		death_sfx.play()
		animation_player.play("death")
