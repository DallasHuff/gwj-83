class_name Projectile
extends Node2D

var player: Sprite2D

@onready var sprite: Sprite2D = %Sprite2D


func _process(delta: float) -> void:
	if not player:
		player = get_tree().get_first_node_in_group("player")
		return
	global_position.x = move_toward(global_position.x, player.global_position.x, delta)
	global_position.y = move_toward(global_position.y, player.global_position.y, delta)
	if (player.global_position - global_position).length() < 5:
		queue_free()
