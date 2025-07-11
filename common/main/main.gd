class_name Main
extends Node

@export var enemy_scene: PackedScene


func _ready() -> void:
	Global.main = self
	var enemy: Node2D = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = Vector2.ZERO
