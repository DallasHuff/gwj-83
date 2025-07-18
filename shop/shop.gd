class_name Shop
extends Control

@export var attack_damage_upgrade: Upgrade
var blood: int = 5
var souls: int = 1
var memories: int = 1
var upgrade_containers: Array[UpgradeContainer] = []

@onready var blood_count_label: Label = %BloodCountLabel
@onready var soul_count_label: Label = %SoulsCountLabel
@onready var memories_count_label: Label = %MemoriesCountLabel
@onready var boss_battle_upgrade: UpgradeContainer = %BossBattle
@onready var number_enemies_upgrade: UpgradeContainer = %NumberEnemies


func _ready() -> void:
	CombatEvents.new_game_started.connect(_on_new_game)
	CombatEvents.blood_gained.connect(_on_blood_gained)
	CombatEvents.souls_gained.connect(_on_souls_gained)
	CombatEvents.memories_gained.connect(_on_memories_gained)
	for node in get_tree().get_nodes_in_group("upgrade_container"):
		upgrade_containers.append(node as UpgradeContainer)
	if upgrade_containers.size() != 14:
		push_error("wrong number of upgrade containers. Expected 14 but got: ", upgrade_containers.size())

	for uc in upgrade_containers:
		uc.purchased.connect(update_currency_labels)

	boss_battle_upgrade.purchased.connect(func()->void:CombatEvents.boss_purchased.emit())
	number_enemies_upgrade.purchased.connect(func()->void:CombatEvents.enemy_slot_added.emit())

	update_currency_labels()


func set_max_level(button: Button, label: Label) -> void:
	if button and label:
		return


func update_currency_labels() -> void:
	blood_count_label.text = str(blood)
	soul_count_label.text = str(souls)
	memories_count_label.text = str(memories)


func _on_new_game() -> void:
	blood = 0
	souls = 0
	memories = 0


func _on_blood_gained(amount: int) -> void:
	blood += amount
	update_currency_labels()
	

func _on_souls_gained(amount: int) -> void: 
	souls += amount
	update_currency_labels()


func _on_memories_gained(amount: int) -> void: 
	memories += amount
	update_currency_labels()
