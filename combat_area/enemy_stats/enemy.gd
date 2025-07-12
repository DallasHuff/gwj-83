class_name Enemy
extends Node2D

signal died

var stats: EnemyStats : set = _set_stats

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D


func _set_stats(value: EnemyStats) -> void:
	if not value:
		push_error("no stats")
		return

	stats = value.duplicate()
	sprite.sprite_frames = stats.sprite_frames
	stats.changed.connect(_on_stats_changed)


func die() -> void:
	CombatEvents.blood_gained.emit(stats.blood)
	CombatEvents.souls_gained.emit(stats.souls)
	CombatEvents.memories_gained.emit(stats.memories)


func _on_stats_changed() -> void:
	if stats.health <= 0:
		die()
