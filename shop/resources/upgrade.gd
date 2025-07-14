class_name Upgrade
extends Resource

signal level_changed

"""
These are dictionaries where the key is upgrade level, and the value is currency cost.
"""
@export var starting_level: int
@export var blood_cost: Dictionary[int, int]
@export var souls_cost: Dictionary[int, int]
@export var memories_cost: Dictionary[int, int]
var level: int : set = _set_level


func check_max_level() -> bool:
	if blood_cost.has(level):
		return false
	if souls_cost.has(level):
		return false
	if memories_cost.has(level):
		return false
	return true


func can_purchase() -> bool:
	if blood_cost.has(level) and Global.main.shop.blood < blood_cost[level]:
		return false
	if souls_cost.has(level) and Global.main.shop.souls < souls_cost[level]:
		return false
	if memories_cost.has(level) and Global.main.shop.memories < memories_cost[level]:
		return false
	return true


func spend_currencies() -> void:
	if blood_cost.has(level):
		Global.main.shop.blood -= blood_cost[level]
	if souls_cost.has(level):
		Global.main.shop.souls -= souls_cost[level]
	if memories_cost.has(level):
		Global.main.shop.memories -= memories_cost[level]


func reset() -> void:
	level = starting_level


func _set_level(value: int) -> void:
	level = value
	level_changed.emit()
