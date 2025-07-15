extends HBoxContainer

@onready var pot_1: TextureButton = $TextureButton
@onready var pot_2: TextureButton = $TextureButton2
@onready var sfx: AudioStreamPlayer = %AudioStreamPlayer


func _ready() -> void:
	pot_1.pressed.connect(_on_pot_pressed.bind(pot_1))
	pot_2.pressed.connect(_on_pot_pressed.bind(pot_2))


func _on_pot_pressed(pot: TextureButton) -> void:
	var player_max_hp := Player.max_health_dict[Player.max_health.level]
	if Player.current_health < (player_max_hp * 0.9):
		pot.disabled = true
		Player.current_health = player_max_hp
		sfx.play()
