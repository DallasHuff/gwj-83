extends Resource
class_name ShopData

# costs 
var attack_damage_cost: Dictionary = {
	0: 1,
	1: 1, 
	2: 1,
	3: 2, 
	4: 2,
	5: 2,
	6: 2,
	7: 2,
	8: 3,
	9: 3,
	10: 4
}
var attack_damage_cost1: Dictionary = {
	0: 1,
	1: 2, 
	2: 3,
	3: 4,
	4: 5,
}
var attack_speed_cost: Dictionary = {
	1: 1,
	2: 1,
	3: 1,
	4: 2,
	5: 2,
	6: 2,
	7: 3,
	8: 3,
	9: 4,
	10: 4,
}
var life_steal_cost: Dictionary = {
	0: 1,
	1: 2, 
	2: 3,
	3: 4,
	4: 5,
}
var health_upgrade_cost: Dictionary = {
	0: 1,
	1: 2, 
	2: 3,
	3: 4,
	4: 5,
}
var armor_upgrade_cost: Dictionary = {
	0: 1,
	1: 2, 
	2: 3,
	3: 4,
	4: 5,
}
var spell_power_cost: Dictionary = {
	0: 1,
	1: 2, 
	2: 3,
	3: 4,
	4: 5,
}
var mana_regen_cost: Dictionary = {
	0: 1,
	1: 2, 
	2: 3,
	3: 4,
	4: 5,
}
var enemy_spawn_seed_cost: Dictionary = {
	0: 1,
	1: 2, 
	2: 3,
	3: 4,
	4: 5,
}
var amount_spawned_cost: Dictionary = {
	0: 1,
	1: 2, 
	2: 3,
	3: 4,
	4: 5,
}
var enemy_health_increase_cost: Dictionary = {
	0: 1,
	1: 2, 
	2: 3,
	3: 4,
	4: 5,
}

# levels 
var attack_damage_level: int = 0 
var attack_speed_level: int = 0 
var life_steal_level: int = 0 
var health_upgrade_level: int = 0
var armor_upgrade_level: int = 0
var spell_power_level: int = 0
var mana_regen_level: int = 0
var enemy_spawn_seed_level: int = 0
var amount_spawned_level: int = 0
var enemy_health_increase_level: int = 0

# Currency
var blood: int = 0
var souls: int = 0
var memories: int = 0
