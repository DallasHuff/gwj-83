class_name CurrencyMover
extends Node

@export var blood_particles: PackedScene
@export var soul_particles: PackedScene
@export var memory_particles: PackedScene
var blood_scene := load("res://combat_area/currencies/blood.tscn")
var soul_scene := load("res://combat_area/currencies/soul.tscn")
var memory_scene := load("res://combat_area/currencies/memory.tscn")

@onready var player: Node2D = %PlayerSprite


func _ready() -> void:
	CombatEvents.enemy_died.connect(_on_enemy_died)
	
func _on_enemy_died(enemy: Enemy) -> void:
	var cur_instance: Node2D
	var bloods: int = enemy.stats.blood
	var souls: int = enemy.stats.souls
	var memories: int = enemy.stats.memories
	if enemy.stats.blood > 0:
		cur_instance = blood_scene.instantiate()
	elif enemy.stats.souls > 0:
		cur_instance = soul_scene.instantiate() 
	elif enemy.stats.memories > 0:
		cur_instance = memory_scene.instantiate() 
	else:
		push_warning("loot not set up for enemy")
		return 
		
	cur_instance.global_position = Vector2(enemy.global_position.x, enemy.global_position.y + 35)

	Global.main.game.add_child(cur_instance)
		
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(cur_instance, "global_position", player.global_position, 1)
	tween.tween_interval(.2)
	tween.tween_callback(cur_instance.queue_free)
	tween.tween_callback(CombatEvents.blood_gained.emit.bind(bloods))
	tween.tween_callback(CombatEvents.souls_gained.emit.bind(souls))
	tween.tween_callback(CombatEvents.memories_gained.emit.bind(memories))
