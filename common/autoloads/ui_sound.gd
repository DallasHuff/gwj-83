extends Node2D

var button_press_sounds: Array[AudioStreamPlayer] = []
var button_hover_sounds: Array[AudioStreamPlayer] = []

@onready var press_1: AudioStreamPlayer = $ButtonSound
@onready var hover_1: AudioStreamPlayer = $ButtonHoverSound


func _ready() -> void:
	# when _ready is called, there might already be nodes in the tree, so connect all existing buttons
	connect_buttons(get_tree().root)
	get_tree().node_added.connect(_on_tree_node_added)

	button_press_sounds = [press_1]
	button_hover_sounds = 


func _on_tree_node_added(node: Node) -> void:
	if node is Button:
		connect_to_button(node)


func _on_button_pressed() -> void:
	button_press_sounds.pick_random().play()


func _on_mouse_entered() -> void:
	button_hover_sounds.pick_random().play()


# recursively connect all buttons
func connect_buttons(root: Node) -> void:
	for child in root.get_children():
		if child is BaseButton:
			connect_to_button(child)
		connect_buttons(child)


func connect_to_button(button: Button) -> void:
	button.pressed.connect(_on_button_pressed)
	button.mouse_entered.connect(_on_mouse_entered)
