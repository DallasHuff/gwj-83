class_name SettingsMenu
extends Control

@onready var fullscreen: CheckBox = %FullscreenButton
@onready var master_volume: HSlider = %MasterVolumeSlider
@onready var sfx_volume: HSlider = %SFXVolumeSlider
@onready var music_volume: HSlider = %MusicVolumeSlider
@onready var controller_mouse_sens: HSlider = %MouseSensSlider
@onready var controller_mouse_toggle: CheckBox = %ControllerMouseToggle
@onready var exit_button: Button = %ExitButton


func _ready() -> void:
	# Connect to methods
	controller_mouse_sens.drag_ended.connect(_on_mouse_sensitivity_changed)
	controller_mouse_toggle.toggled.connect(_on_controller_mouse_toggled)

	# Pull values from settings.gd
	fullscreen.button_pressed = Settings.full_screen
	master_volume.value = Settings.music_volume
	sfx_volume.value = Settings.sfx_volume
	music_volume.value = Settings.music_volume
	controller_mouse_sens.value = Settings.controller_mouse_sens
	controller_mouse_toggle.button_pressed = Settings.controller_mouse_toggle


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


func _on_mouse_sensitivity_changed(_value: float) -> void:
	Settings.controller_mouse_sens = controller_mouse_sens.value
	print(controller_mouse_sens.value)


func _on_controller_mouse_toggled(toggled_on: bool) -> void:
	Settings.controller_mouse_toggle = toggled_on


func convert_percentage_to_decibels(percent: float) -> float:
	const _scale: float = 20.0
	const _divisor: float = 50.0
	return _scale * log(percent / _divisor) / log(10)


func _on_exit_button_pressed() -> void:
	Global.main.add_main_menu()
	queue_free()
