extends Node2D

var lights: Array[PointLight2D]


func _ready() -> void:
	for node in get_children():
		if node is PointLight2D:
			lights.append(node)
