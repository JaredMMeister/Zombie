extends Node

signal stat_change

var invincible: bool = false
var current_gun_damage: int
var max_zombies: int = 6
var can_shoot: bool = true
var is_reloading: bool = false
var killed_during_level: int = 0

var current_level: int = 1:
	get:
		return current_level
	set(value):
		current_level = value
		stat_change.emit()

var current_bullets: int = 6:
	get:
		return current_bullets
	set(value):
		current_bullets = value
		stat_change.emit()
		
var player_health: int = 60:
	get:
		return player_health
	set(value):
		player_health = value
		stat_change.emit()
		
var total_money: int = 0:
	get:
		return total_money
	set(value):
		total_money = value
		stat_change.emit()
		


		
	
