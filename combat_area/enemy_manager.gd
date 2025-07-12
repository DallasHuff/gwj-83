class_name EnemyManager
extends Node

const MAX_SLOTS: int = 6

@export var enemy_scene: PackedScene
@export var available_enemies: Array[EnemyStats]
var slot_to_position: Dictionary[int, Vector2] = {
	0 : Vector2(266, 96),
	1 : Vector2(320, 160),
	2 : Vector2(321, 42),
	3 : Vector2(215, 162),
	4 : Vector2(217, 35),
	5 : Vector2(169, 94),
}
var highest_slot_unlocked: int = 0
var enemies: Array[Enemy] = []


func _ready() -> void:
	enemies.resize(MAX_SLOTS)
	enemies.fill(null)
	for i in range(highest_slot_unlocked):
		add_new_enemy(i)


func add_new_enemy(slot: int) -> void:
	var e: Enemy = enemy_scene.instantiate()
	enemies[slot] = e
	
	e.stats = available_enemies.pick_random()

	Global.main.game.add_child(e)
	e.global_position = slot_to_position[slot]


func _on_slot_added() -> void:
	highest_slot_unlocked += 1
	if highest_slot_unlocked > MAX_SLOTS:
		push_error("unlocked too many enemy slots!")
		highest_slot_unlocked -= 1
		return
	
	add_new_enemy(highest_slot_unlocked)
