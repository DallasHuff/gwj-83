extends Node

var blood: int = 0
var souls: int = 0
var memories: int = 0


func _ready() -> void:
	CombatEvents.blood_gained.connect(_on_blood_gained)
	CombatEvents.souls_gained.connect(_on_souls_gained)
	CombatEvents.memories_gained.connect(_on_memories_gained)


func _on_blood_gained(amount: int) -> void:
	blood += amount


func _on_souls_gained(amount: int) -> void:
	souls += amount


func _on_memories_gained(amount: int) -> void:
	memories += amount
