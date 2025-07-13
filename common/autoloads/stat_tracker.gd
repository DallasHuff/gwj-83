extends Node

var time_elapsed: float
var enemies_killed: int
var blood_consumed: int
var souls_consumed: int
var memories_consumed: int


func _ready() -> void:
	CombatEvents.new_game_started.connect(_on_new_game_started)
	CombatEvents.enemy_died.connect(func(_e:Enemy)->void:enemies_killed += 1)
	CombatEvents.blood_gained.connect(func(i:int)->void:blood_consumed += i)
	CombatEvents.souls_gained.connect(func(i:int)->void:souls_consumed += i)
	CombatEvents.memories_gained.connect(func(i:int)->void:memories_consumed += i)


func _process(delta: float) -> void:
	time_elapsed += delta


func _on_new_game_started() -> void:
	time_elapsed = 0
	enemies_killed = 0
	blood_consumed = 0
	souls_consumed = 0
	memories_consumed = 0
