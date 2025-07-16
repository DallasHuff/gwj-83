class_name GameOverMenu
extends Control

@onready var win_lose_label: Label = %WinLoseLabel
@onready var main_menu_button: Button = %MainMenuButton
@onready var new_game_button: Button = %NewGameButton
@onready var time_elapsed: Label = %TimeSpent
@onready var enemies_killed: Label = %EnemiesKilled
@onready var blood_consumed: Label = %BloodConsumed
@onready var souls_consumed: Label = %SoulsConsumed
@onready var memories_consumed: Label = %MemoriesConsumed


func _ready() -> void:
	var hours: int = 0
	var minutes: int = 0
	var seconds := StatTracker.time_elapsed
	while seconds > 3600:
		hours += 1
		seconds -= 3600
	while seconds > 60:
		minutes += 1
		seconds -= 60
	time_elapsed.text = str(str(hours).pad_zeros(2), ":", str(minutes).pad_zeros(2), ":", str(int(seconds)).pad_zeros(2))
	enemies_killed.text = str(StatTracker.enemies_killed)
	blood_consumed.text = str(StatTracker.blood_consumed)
	souls_consumed.text = str(StatTracker.souls_consumed)
	memories_consumed.text = str(StatTracker.memories_consumed)
