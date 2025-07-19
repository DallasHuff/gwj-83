class_name EnemyStats
extends Resource

@export_category("visuals")
@export var sprite_frames: SpriteFrames
@export var projectile_texture: Texture2D
@export var death_sfx: AudioStream
@export var attack_sfx: AudioStream
@export_category("battle stats")
@export var health: float : set = _set_health
@export var damage: float
@export var time_between_attacks: float
@export_category("loot")
@export var blood: int
@export var souls: int
@export var memories: int
var current_health: float : set = _set_current_health


func _set_health(value: float) -> void:
	health = value
	emit_changed()


func _set_current_health(value: float) -> void:
	current_health = value
	emit_changed()
