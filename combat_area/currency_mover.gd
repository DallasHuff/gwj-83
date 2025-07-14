class_name CurrencyMover
extends Node

@export var blood_particles: PackedScene
@export var soul_particles: PackedScene
@export var memory_particles: PackedScene
var blood_scene := load("res://combat_area/currencies/blood.tscn")
var soul_scene := load("res://combat_area/currencies/soul.tscn")
var memory_scene := load("res://combat_area/currencies/memory.tscn")

func _ready() -> void:
	CombatEvents.enemy_died.connect(_on_enemy_died)
	
func _on_enemy_died(enemy: Enemy) -> void:
	var target_pos: Vector2 = Vector2(266.0, 120.0)
	var cur_instance: Node2D
	# check which type of currency they drop and instantiate the node 
	if enemy.stats.blood >= 0:
		cur_instance = blood_scene.instantiate()
	elif enemy.stats.souls >= 0:
		cur_instance = soul_scene.instantiate() 
	elif enemy.stats.memories >= 0:
		cur_instance = memory_scene.instantiate() 
	else:
		return 
		
	cur_instance.global_position = Vector2(enemy.global_position.x, enemy.global_position.y + 35)
	
	if Global.main and Global.main.game:
		Global.main.game.add_child(cur_instance)
	else:
		print("Global.main.game issue.")
		
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(cur_instance, "global_position", Vector2(65.0, 120.0), 1)
	tween.tween_interval(.2)
	tween.tween_callback(cur_instance.queue_free)
	print(cur_instance.global_position)
	
	
	# create tween 
	# move cur from enemy pos to player pos 
	# increment player cur val 
	# remove cur scene
