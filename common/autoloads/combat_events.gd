extends Node

signal blood_gained(amount: int)
signal souls_gained(amount: int)
signal memories_gained(amount: int)
signal enemy_died(enemy: Enemy)
signal game_over(win: bool)
signal new_game_started
signal boss_purchased
signal enemy_slot_added
signal enemy_strength_increase(type: int)
