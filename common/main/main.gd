class_name Main
extends Node

@export var game_over_menu_scene: PackedScene
@export var settings_menu: PackedScene
@export var main_menu_scene: PackedScene
@export var arena_scene: PackedScene
@export var shop_scene: PackedScene
@export var combat_speed_container: PackedScene
var shop: Shop

@onready var subviewport_container: SubViewportContainer = %SubViewportContainer
@onready var game: SubViewport = %SubViewport
@onready var ui: Control = %UIParent
@onready var music_manager: MusicManager = %MusicManager


func _ready() -> void:
	Global.main = self
	CombatEvents.game_over.connect(_on_game_over)
	go_arena()


func clear_children() -> void:
	for node in game.get_children():
		node.queue_free()
	for node in ui.get_children():
		node.queue_free()


func go_main_menu() -> void:
	get_tree().paused = false
	music_manager.play_main_menu()
	clear_children()
	var main_menu: MainMenu = main_menu_scene.instantiate()
	ui.add_child(main_menu)
	main_menu.position = Vector2.ZERO
	main_menu.play_button.pressed.connect(go_arena)
	main_menu.play_button.pressed.connect(func()->void:print("play button pressed"))
	main_menu.settings_button.pressed.connect(go_settings)
	main_menu.exit_button.pressed.connect(func()->void:get_tree().quit(0))


func go_arena() -> void:
	music_manager.play_arena()
	clear_children()
	CombatEvents.new_game_started.emit()
	var arena: Arena = arena_scene.instantiate()
	game.add_child(arena)
	arena.position = Vector2.ZERO
	shop = shop_scene.instantiate()
	ui.add_child(shop)
	shop.position = Vector2.ZERO
	var speed_buttons_container: Control = combat_speed_container.instantiate()
	ui.add_child(speed_buttons_container)
	speed_buttons_container.position = Vector2.ZERO


func go_settings() -> void:
	clear_children()
	var settings: SettingsMenu = settings_menu.instantiate()
	ui.add_child(settings)
	settings.position = Vector2.ZERO
	settings.exit_button.pressed.connect(go_main_menu)


func _on_game_over(win: bool) -> void:
	var game_over: GameOverMenu = game_over_menu_scene.instantiate()
	ui.add_child(game_over)
	if win:
		game_over.win_lose_label.text = "YOU WIN!!"
	else:
		game_over.win_lose_label.text = "YOU LOSE!!"
	game_over.global_position = Vector2.ZERO
	game_over.main_menu_button.pressed.connect(go_main_menu)
	game_over.new_game_button.pressed.connect(go_arena)
	get_tree().paused = true
