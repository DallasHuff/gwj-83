class_name MusicManager
extends Node2D

@onready var main_menu: AudioStreamPlayer2D = %MainMenuMusic
@onready var arena_1: AudioStreamPlayer2D = %ArenaMusic1
@onready var arena_2: AudioStreamPlayer2D = %ArenaMusic2


func play_main_menu() -> void:
	if main_menu.playing:
		return
	_fade_in(main_menu, 5)
	_fade_out(arena_1, 5)
	_fade_out(arena_2, 5)


func play_arena() -> void:
	if arena_1.playing or arena_2.playing:
		return
	_fade_in(arena_2, 5)
	_fade_out(main_menu, 5)


func _fade_in(music: AudioStreamPlayer2D, time: float) -> void:
	music.volume_db = -50
	music.play()
	var tween := create_tween()
	tween.tween_property(music, "volume_db", 0, time)


func _fade_out(music: AudioStreamPlayer2D, time: float) -> void:
	var tween := create_tween()
	tween.tween_property(music, "volume_db", -50, time)
	tween.tween_callback(music.stop)
