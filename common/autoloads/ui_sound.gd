extends Node2D

func _ready() -> void:
	# when _ready is called, there might already be nodes in the tree, so connect all existing buttons
	connect_buttons(get_tree().root)
	get_tree().node_added.connect(_on_SceneTree_node_added)

func _on_SceneTree_node_added(node: Node) -> void:
	if node is Button:
		connect_to_button(node)

func _on_Button_pressed() -> void:
	$ButtonSound.play()
	
func _on_Mouse_entered() -> void:
	$ButtonHoverSound.play()

# recursively connect all buttons
func connect_buttons(root: Node) -> void:
	for child in root.get_children():
		if child is BaseButton:
			connect_to_button(child)
		connect_buttons(child)

func connect_to_button(button: Button) -> void:
	button.pressed.connect(_on_Button_pressed)
	button.mouse_entered.connect(_on_Mouse_entered)
