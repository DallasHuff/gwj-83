extends Control

# Buttons
@onready var attack_damage_button: Button = %AttackDamageButton
@onready var attack_speed_button: Button = %AttackSpeedButton
@onready var life_steal_button: Button = %LifeStealButton
@onready var health_upgrade_button: Button = %HealthUpgradeButton
@onready var armor_upgrade_button: Button = %ArmorUpgradeButton # need to implement 
@onready var spell_power_button: Button = %SpellPowerButton
@onready var mana_regen_button: Button = %ManaRegenButton
@onready var enemy_spawn_button: Button = %EnemySpawnButton
@onready var amount_spawned_button: Button = %AmountSpawnedButton
@onready var enemy_health_button: Button = %EnemyHealthButton

# Labels
@onready var ability_price_1: Label = %AbilityPrice1
@onready var ability_price_2: Label = %AbilityPrice2
@onready var ability_price_3: Label = %AbilityPrice3
@onready var ability_price_4: Label = %AbilityPrice4
@onready var ability_price_5: Label = %AbilityPrice5
@onready var ability_price_6: Label = %AbilityPrice6
@onready var ability_price_7: Label = %AbilityPrice7
@onready var ability_price_8: Label = %AbilityPrice8
@onready var ability_price_9: Label = %AbilityPrice9
@onready var armor_price_label: Label = %ArmorPriceLabel

@onready var ability_level_1: Label = %AbilityLevel1
@onready var ability_level_2: Label = %AbilityLevel2
@onready var ability_level_3: Label = %AbilityLevel3
@onready var ability_level_4: Label = %AbilityLevel4
@onready var ability_level_5: Label = %AbilityLevel5
@onready var ability_level_6: Label = %AbilityLevel6
@onready var ability_level_7: Label = %AbilityLevel7
@onready var ability_level_8: Label = %AbilityLevel8
@onready var ability_level_9: Label = %AbilityLevel9
@onready var armor_level_label: Label = %ArmorLevelLabel

@export var shop_data: ShopData

var blood: int = 10
var souls: int = 10
var memories: int = 10

var attk_dam_cost_cycle: int = 0
var attk_spd_cost_cycle: int = 0
var life_steal_cost_cycle: int = 0
var health_upgrade_cost_cycle: int = 0
var spell_power_cost_cycle: int = 0
var mana_regen_cost_cycle: int = 0
var enemy_spawn_cost_cycle: int = 0
var amount_spawned_cost_cycle: int = 0
var enemy_health_cost_cycle: int = 0
var armor_upgrade_cost_cycle: int = 0

func _ready() -> void:
	#CombatEvents.blood_gained.connect(_on_blood_gained)
	#CombatEvents.blood_gained.connect(_on_blood_gained)
	#CombatEvents.blood_gained.connect(_on_blood_gained)
	
	shop_data = shop_data.duplicate()
	#self.shop_data = shop_data
	# should I be assigning them all to self.shop_data? They all seem to work...
	
	attack_damage_button.pressed.connect(_on_attk_dam_button_pressed)
	attack_speed_button.pressed.connect(_on_attk_speed_button_pressed)
	life_steal_button.pressed.connect(_on_life_steal_button_pressed)
	health_upgrade_button.pressed.connect(_on_health_upgrade_button_pressed)
	spell_power_button.pressed.connect(_on_spell_power_button_pressed)
	mana_regen_button.pressed.connect(_on_mana_regen_button_pressed)
	enemy_spawn_button.pressed.connect(_on_enemy_spawn_button_pressed)
	amount_spawned_button.pressed.connect(_on_amount_spawned_button_pressed)
	enemy_health_button.pressed.connect(_on_enemy_health_button_pressed)
	armor_upgrade_button.pressed.connect(_on_armor_upgrade_button_pressed)
	
	ability_price_1.text = (str("Cost: $", self.shop_data.attack_damage_cost[0]))
	ability_price_2.text = str("Cost: $", self.shop_data.attack_speed_cost[0])
	ability_price_3.text = str("Cost: $", self.shop_data.life_steal_cost[0])
	ability_price_4.text = str("Cost: $", self.shop_data.health_upgrade_cost[0])
	ability_price_5.text = str("Cost: $", self.shop_data.spell_power_cost[0])
	ability_price_6.text = str("Cost: $", self.shop_data.mana_regen_cost[0])
	ability_price_7.text = str("Cost: $", self.shop_data.enemy_spawn_seed_cost[0])
	ability_price_8.text = str("Cost: $", self.shop_data.amount_spawned_cost[0])
	ability_price_9.text = str("Cost: $", self.shop_data.enemy_health_increase_cost[0])
	armor_price_label.text = str("Cost: $", self.shop_data.armor_upgrade_cost[0])
func _process(delta: float) -> void:


	
	ability_level_1.text = str(self.shop_data.attack_damage_level)
	ability_level_2.text = str(self.shop_data.attack_speed_level)
	ability_level_3.text = str(self.shop_data.life_steal_level)
	ability_level_4.text = str(self.shop_data.health_upgrade_level)
	ability_level_5.text = str(self.shop_data.spell_power_level)
	ability_level_6.text = str(self.shop_data.mana_regen_level)
	ability_level_7.text = str(self.shop_data.enemy_spawn_seed_level)
	ability_level_8.text = str(self.shop_data.amount_spawned_level)
	ability_level_9.text = str(self.shop_data.enemy_health_increase_level)
	armor_level_label.text = str(self.shop_data.armor_upgrade_level)
	
# handling buttons 
func _on_attk_dam_button_pressed() -> void:
	if blood >= shop_data.attack_damage_cost[attk_dam_cost_cycle]:
		shop_data.attack_damage_level += 1 
		print("blood: ", blood, " ", "cost: ", shop_data.attack_damage_cost[attk_dam_cost_cycle])
		attk_dam_cost_cycle += 1
		blood -= shop_data.attack_damage_cost[attk_dam_cost_cycle]
		ability_price_1.text = str("Cost: $", self.shop_data.attack_damage_cost[attk_dam_cost_cycle])
		
func _on_attk_speed_button_pressed() -> void:
	if blood >= shop_data.attack_speed_cost[attk_spd_cost_cycle]:
		shop_data.attack_speed_level += 1
		attk_spd_cost_cycle += 1
		blood -= shop_data.attack_speed_cost[attk_spd_cost_cycle]
		ability_price_2.text = str("Cost: $", self.shop_data.attack_speed_cost[attk_spd_cost_cycle])

func _on_life_steal_button_pressed() -> void:
	if blood >= shop_data.life_steal_cost[life_steal_cost_cycle]:
		shop_data.life_steal_level += 1
		life_steal_cost_cycle += 1
		blood -= shop_data.life_steal_cost[life_steal_cost_cycle]
		ability_price_3.text = str("Cost: $", self.shop_data.life_steal_cost[life_steal_cost_cycle])

func _on_health_upgrade_button_pressed() -> void:
	if blood >= shop_data.health_upgrade_cost[health_upgrade_cost_cycle]:
		shop_data.health_upgrade_level += 1
		health_upgrade_cost_cycle += 1
		blood -= shop_data.health_upgrade_cost[health_upgrade_cost_cycle]
		ability_price_4.text = str("Cost: $", self.shop_data.health_upgrade_cost[health_upgrade_cost_cycle])
	
func _on_spell_power_button_pressed() -> void:
	if souls >= shop_data.spell_power_cost[spell_power_cost_cycle]:
		shop_data.spell_power_level += 1
		spell_power_cost_cycle += 1
		souls -= shop_data.spell_power_cost[spell_power_cost_cycle]
		ability_price_5.text = str("Cost: $", self.shop_data.spell_power_cost[spell_power_cost_cycle])

		
func _on_mana_regen_button_pressed() -> void:
	if souls >= shop_data.mana_regen_cost[mana_regen_cost_cycle]:
		shop_data.mana_regen_level += 1
		mana_regen_cost_cycle += 1
		print(shop_data.mana_regen_level)
		souls -= shop_data.mana_regen_cost[mana_regen_cost_cycle]
		ability_price_6.text = str("Cost: $", self.shop_data.mana_regen_cost[mana_regen_cost_cycle])

func _on_enemy_spawn_button_pressed() -> void:
	if memories >= shop_data.enemy_spawn_seed_cost[enemy_spawn_cost_cycle]:
		shop_data.enemy_spawn_seed_level += 1
		enemy_spawn_cost_cycle += 1
		memories -= shop_data.enemy_spawn_seed_cost[enemy_spawn_cost_cycle]
		ability_price_7.text = str("Cost: $", self.shop_data.enemy_spawn_seed_cost[enemy_spawn_cost_cycle])

func _on_amount_spawned_button_pressed() -> void:
	if memories >= shop_data.amount_spawned_cost[amount_spawned_cost_cycle]:
		shop_data.amount_spawned_level += 1
		amount_spawned_cost_cycle += 1
		memories -= shop_data.amount_spawned_cost[amount_spawned_cost_cycle]
		ability_price_8.text = str("Cost: $", self.shop_data.amount_spawned_cost[amount_spawned_cost_cycle])
	
func _on_enemy_health_button_pressed() -> void:
	if memories >= shop_data.enemy_health_increase_cost[enemy_health_cost_cycle]:
		shop_data.enemy_health_increase_level += 1
		enemy_health_cost_cycle += 1 
		memories -= shop_data.enemy_health_increase_cost[enemy_health_cost_cycle]
		ability_price_9.text = str("Cost: $", self.shop_data.enemy_health_increase_cost[enemy_health_cost_cycle])

		
func _on_armor_upgrade_button_pressed() -> void: 
	if souls >= shop_data.armor_upgrade_cost[armor_upgrade_cost_cycle]:
		shop_data.armor_upgrade_level += 1
		armor_upgrade_cost_cycle += 1
		souls -= shop_data.armor_upgrade_cost[armor_upgrade_cost_cycle]
		print("Souls after buying armor: ", souls)
		armor_price_label.text = str("Cost: $", self.shop_data.armor_upgrade_cost[armor_upgrade_cost_cycle])

# create a resource for the values of the abilities? 

func _on_blood_gained(amount: int) -> void:
	blood += amount 
	
func _on_souls_gained(amount: int) -> void: 
	souls += amount 
	
func _on_memories_gained(amount: int) -> void: 
	memories += amount 
