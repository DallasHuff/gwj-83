class_name CombatText
extends Label

const MOVING_HEIGHT := Vector2(0, -60)

var type_to_color: Dictionary[CombatTextMaker.Type, Color] = {
	CombatTextMaker.Type.DAMAGE : Color("e19600"),
	CombatTextMaker.Type.HEALING : Color(0, 1, 0, 1),
	CombatTextMaker.Type.SPELL : Color("007bbb"),
}


func setup(value: float, crit: bool, type: CombatTextMaker.Type) -> void:
	text = str(int(value))
	add_theme_color_override("font_color", type_to_color[type])
	if crit:
		add_theme_font_size_override("font_size", 65)
	else:
		add_theme_font_size_override("font_size", 40)
	tween_self()


func tween_self() -> void:
	var tween := create_tween()
	tween.tween_property(self, "global_position", global_position + MOVING_HEIGHT, 2)
	tween.parallel().tween_property(self, "modulate:a", 0, 2)
	tween.tween_callback(queue_free)
