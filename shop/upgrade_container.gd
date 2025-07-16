class_name UpgradeContainer
extends HBoxContainer

signal purchased

const BLOOD: Texture2D = preload("res://assets/icons/blood/hd_bright_blood.png")
const SOUL: Texture2D = preload("res://assets/icons/souls/hd_soul_2.png")
const MEM: Texture2D = preload("res://assets/icons/memory_crystals/hd_memory_crystal.png")

@export var upgrade: Upgrade

@onready var level_label: Label = $Level
@onready var price_label: RichTextLabel = $Price
@onready var button: Button = $Button


func _ready() -> void:
	CombatEvents.new_game_started.connect(func()->void:upgrade.reset())
	button.pressed.connect(_on_button_pressed)
	add_to_group("upgrade_container")
	set_price_label()


func _on_button_pressed() -> void:
	if upgrade.can_purchase():
		upgrade.spend_currencies()
		upgrade.level += 1
		level_label.text = str(upgrade.level)
		set_price_label()
	if upgrade.check_max_level():
		set_max_level()


func set_max_level() -> void:
	price_label.text = "MAX"
	button.disabled = true


func set_price_label() -> void:
	price_label.clear()
	price_label.add_image(BLOOD, 32, 32, Color(1,1,1), 5, Rect2(0,0,0,0), null, false, "BLOOD")
	price_label.add_text(str(" ", get_cost(upgrade.blood_cost), " "))
	price_label.add_image(SOUL, 32, 32, Color(1,1,1), 5, Rect2(0,0,0,0), null, false, "SOULS")
	price_label.add_text(str(" ", get_cost(upgrade.souls_cost), " "))
	price_label.add_image(MEM, 32, 32, Color(1,1,1), 5, Rect2(0,0,0,0), null, false, "MEMORY CRYSTALS")
	price_label.add_text(str(" ", get_cost(upgrade.memories_cost), " "))


func get_cost(cost_dict: Dictionary) -> String:
	if cost_dict.has(upgrade.level):
		return str(cost_dict[upgrade.level])
	return "0"
