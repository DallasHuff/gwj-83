class_name CurrencyMover
extends Node

@export var blood_particles: PackedScene
@export var soul_particles: PackedScene
@export var memory_particles: PackedScene


func _ready() -> void:
	CombatEvents.enemy_died.connect(_on_enemy_died)


func _on_enemy_died(_enemy: Enemy) -> void:
	pass
