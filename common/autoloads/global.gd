extends Node

var test: PackedScene = preload("res://combat_area/currencies/soul.tscn")
var main: Main
# Have to use a magic number here.
# I'm not sure how to eloquently get the arena offset on the y axis
var arena_offset := Vector2(0, 160)


func arena_to_ui_position(arena_position: Vector2) -> Vector2:
	return arena_position * main.subviewport_container.stretch_shrink + arena_offset
