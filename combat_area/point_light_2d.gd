extends PointLight2D

var pulsate_time: float
var current_time: float
var direction: bool # true means we are increasing energy, false means we are decreasing


func _ready() -> void:
	pulsate_time = randf_range(2.5, 3.5)


func _process(delta: float) -> void:
	# Increase energy
	if direction:
		energy += delta / pulsate_time
	else: # Decrease energy
		energy -= delta / pulsate_time
	
	if energy < 1:
		direction = true
	elif energy > 1.5:
		direction = false
