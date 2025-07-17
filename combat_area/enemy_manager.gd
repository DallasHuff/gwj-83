class_name EnemyManager
extends Node

const MAX_SLOTS: int = 6

@export var enemy_scene: PackedScene
@export var boss_scene: PackedScene
@export var available_enemies: Array[EnemyStats]
var slot_to_position: Dictionary[int, Vector2] = {
	0 : Vector2(92, 104),
	1 : Vector2(35, 162),
	2 : Vector2(36, 30),
	3 : Vector2(128, 32),
	4 : Vector2(177, 162),
	5 : Vector2(211, 93),
}
var enemy_spawn_speed: float = 1
var highest_slot_unlocked: int = 0
var enemies: Array[Enemy] = []
var boss_purchased := false


func _ready() -> void:
	enemies.resize(MAX_SLOTS)
	enemies.fill(null)
	for i in range(highest_slot_unlocked+1):
		add_new_enemy(i)

	CombatEvents.boss_purchased.connect(_on_boss_purchased)
	CombatEvents.enemy_slot_added.connect(_on_slot_added)


func add_new_enemy(slot: int) -> void:
	var e: Enemy = enemy_scene.instantiate()
	e.died.connect(_on_enemy_died.bind(slot))
	e.attacked.connect(_on_enemy_attacked.bind(e))
	
	e.stats = available_enemies.pick_random()

	Global.main.game.add_child(e)
	e.global_position = Vector2(-200, slot_to_position[slot].y)
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(e, "global_position", slot_to_position[slot], 1)
	tween.tween_callback(func()->void: enemies[slot] = e; e.in_combat = true)


func _on_enemy_died(slot: int) -> void:
	if is_instance_valid(enemies[slot]):
		enemies[slot].hide()
		if enemies[slot].death_sfx.playing:
			enemies[slot].death_sfx.finished.connect(_free_enemy.bind(enemies[slot]))
		else:
			enemies[slot].queue_free()
		enemies[slot] = null
	await get_tree().create_timer(enemy_spawn_speed).timeout
	if not boss_purchased:
		add_new_enemy(slot)


func _on_boss_purchased() -> void:
	print("boss purchased")
	# Kill all enemies and don't replace them
	boss_purchased = true
	for enemy in enemies:
		if not enemy:
			continue
		enemy.queue_free()
	await get_tree().create_timer(1.5).timeout
	# Create boss
	var boss: Enemy = boss_scene.instantiate()
	boss.stats = load("res://combat_area/enemy_stats/boss/boss1/boss1.tres")
	Global.main.game.add_child(boss)
	boss.died.connect(func()->void:CombatEvents.game_over.emit(true))
	boss.attacked.connect(_on_enemy_attacked.bind(boss))
	boss.global_position = Vector2(-200, 160)
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(boss, "global_position", Vector2(120, 160), 1)
	tween.tween_callback(func()->void: enemies[0] = boss; boss.in_combat = true)
	print(boss.global_position)


func _on_enemy_attacked(enemy: Enemy) -> void:
	Player.current_health -= enemy.stats.damage * Player.defense_dict[Player.defense.level]


func _on_slot_added() -> void:
	highest_slot_unlocked += 1
	if highest_slot_unlocked > MAX_SLOTS:
		push_error("unlocked too many enemy slots!")
		highest_slot_unlocked -= 1
		return
	
	add_new_enemy(highest_slot_unlocked)


func _free_enemy(e: Enemy) -> void:
	e.queue_free()
