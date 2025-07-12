extends SubViewportContainer

const BASE_SIZE := Vector2(384.0, 216.0)


func _ready() -> void:
	_on_screen_size_changed()
	get_tree().root.size_changed.connect(_on_screen_size_changed)


func _on_screen_size_changed() -> void:
	var screen_size := DisplayServer.window_get_size()
	var ratio: int = floori(min(screen_size.x / BASE_SIZE.x, screen_size.y / BASE_SIZE.y))
	ratio = maxi(1, floori(ratio))
	# stretch_shrink = ratio
	stretch_shrink = 3
