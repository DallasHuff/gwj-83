class_name Main
extends Node

@export var main_menu_scene: PackedScene
@export var arena_scene: PackedScene
@export var shop_scene: PackedScene
@export var combat_speed_container: PackedScene

@onready var game: SubViewport = %SubViewport
@onready var ui: Control = %UIParent


func _ready() -> void:
	Global.main = self
	go_arena()


func go_main_menu() -> void:
	var main_menu: Control = main_menu_scene.instantiate()
	ui.add_child(main_menu)


func go_arena() -> void:
	var arena: Arena = arena_scene.instantiate()
	game.add_child(arena)
	var shop: Control = shop_scene.instantiate()
	ui.add_child(shop)
	var speed_buttons_container: Control = combat_speed_container.instantiate()
	ui.add_child(speed_buttons_container)
	speed_buttons_container.position = Vector2.ZERO
