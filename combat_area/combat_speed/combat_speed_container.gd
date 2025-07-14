extends HBoxContainer

@onready var pause_play: Button = %PausePlay
@onready var speed_button: Button = %SpeedButton


func _ready() -> void:
	pause_play.pressed.connect(_on_pause_play_pressed)
	speed_button.pressed.connect(_on_speed_button_pressed)
	Engine.time_scale = 1
	get_tree().paused = false


func _on_speed_button_pressed() -> void:
	if is_equal_approx(Engine.time_scale, 1):
		speed_button.text = "2x"
		Engine.time_scale = 2
	elif is_equal_approx(Engine.time_scale, 2):
		Engine.time_scale = 3
		speed_button.text = "3x"
	elif is_equal_approx(Engine.time_scale, 3):
		Engine.time_scale = 1
		speed_button.text = "1x"


func _on_pause_play_pressed() -> void:
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		pause_play.text = "PLAY"
	else:
		pause_play.text = "PAUSE"
