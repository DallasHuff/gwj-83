class_name EnemyStats
extends Resource

@export_category("visuals")
@export var sprite_frames: SpriteFrames
@export_category("battle stats")
@export var health: float : set = _set_health
@export var damage: float
@export var attack_speed: float
@export_category("loot")
@export var blood: int
@export var souls: int
@export var memories: int


func _set_health(value: float) -> void:
	health = value
	emit_changed()
