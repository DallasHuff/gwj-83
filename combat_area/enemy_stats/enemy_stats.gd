class_name EnemyStats
extends Resource

@export_category("visuals")
@export var sprite_frames: SpriteFrames
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
