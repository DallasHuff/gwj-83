extends HBoxContainer

var in_combat := false

@onready var pause_play: Button = %PausePlay
@onready var speed_button: Button = %SpeedButton


func _ready() -> void:
	pause_play.pressed.connect(_on_pause_play_pressed)
	speed_button.pressed.connect(_on_speed_button_pressed)
	set_engine_speed()


func set_engine_speed() -> void:
	if in_combat:
		Engine.time_scale = Settings.battle_speed
	else:
		Engine.time_scale = 1
	get_tree().paused = false


func _on_speed_button_pressed() -> void:
	pass


func _on_pause_play_pressed() -> void:
	get_tree().paused = not get_tree().paused


func _on_combat_started() -> void:
	in_combat = true
	set_engine_speed()


func _on_combat_ended() -> void:
	Engine.time_scale = 1
