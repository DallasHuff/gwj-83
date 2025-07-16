class_name CombatTextMaker
extends Node

enum Type {DAMAGE, HEALING, SPELL}

@export var text_scene: PackedScene
var x_variation: float = 10

func make_text(value: float, arena_position: Vector2, crit: bool=false, type: Type=Type.DAMAGE) -> void:
	var t: CombatText = text_scene.instantiate()
	Global.main.ui.add_child(t)
	var x_variance := randf_range(-1, 1) * x_variation
	t.global_position = Global.arena_to_ui_position(arena_position - Vector2(x_variance, 40))
	t.setup(value, crit, type)
