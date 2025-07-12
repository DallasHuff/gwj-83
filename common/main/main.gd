class_name Main
extends Node

@export var arena_scene: PackedScene
@export var shop_scene: PackedScene

@onready var game: SubViewport = %SubViewport
@onready var ui: Control = %UIParent


func _ready() -> void:
	Global.main = self
	var arena: Arena = arena_scene.instantiate()
	game.add_child(arena)
