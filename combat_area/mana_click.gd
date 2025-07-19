extends Area2D


func _input(event: InputEvent) -> void:
	var col: CollisionShape2D = $CollisionShape2D
	if not col.shape.get_rect().has_point(get_local_mouse_position()):
		return
	if event.is_action_pressed("click"):
		CombatEvents.mana_clicked.emit()
