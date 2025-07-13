class_name SettingsMenu
extends Control

@onready var fullscreen: CheckBox = %FullscreenButton
@onready var master_volume: HSlider = %MasterVolumeSlider
@onready var sfx_volume: HSlider = %SFXVolumeSlider
@onready var music_volume: HSlider = %MusicVolumeSlider
@onready var exit_button: Button = %ExitButton


func _ready() -> void:
	# Connect functions
	fullscreen.toggled.connect(_on_fullscreen_button_toggled)
	master_volume.value_changed.connect(_on_master_volume_slider_value_changed)
	sfx_volume.value_changed.connect(_on_sfx_volume_slider_value_changed)
	music_volume.value_changed.connect(_on_music_volume_slider_value_changed)
	# Pull values from settings.gd
	fullscreen.button_pressed = Settings.full_screen
	master_volume.value = Settings.master_volume
	sfx_volume.value = Settings.sfx_volume
	music_volume.value = Settings.music_volume


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	Settings.full_screen = toggled_on
	if Settings.full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_master_volume_slider_value_changed(value: float) -> void:
	Settings.master_volume = value
	AudioServer.set_bus_volume_db(0, convert_percentage_to_decibels(value))
	

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	Settings.sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), convert_percentage_to_decibels(value))


func _on_music_volume_slider_value_changed(value: float) -> void:
	Settings.music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), convert_percentage_to_decibels(value))


func convert_percentage_to_decibels(percent: float) -> float:
	const _scale: float = 20.0
	const _divisor: float = 50.0
	return _scale * log(percent / _divisor) / log(10)
