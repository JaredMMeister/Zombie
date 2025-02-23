extends Node2D

@onready var tile_map: TileMap = $NavigationRegion2D/TileMap

var bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")
var zombie_scene: PackedScene = preload("res://Scenes/zombie.tscn")
var imported_zombie_resource = preload("res://Resources/zombie_green.tres")
var animated_coin_scene: PackedScene = preload("res://Scenes/animated_coin.tscn")

var can_spawn: bool = true
var spawned_zombie_count: int = 0
var possible_spawn_indices: Array

func _ready():
	set_zombie_spawn_indices()
	#tile_map.tile_set.set_physics_layer_collision_layer(1,1)
	

func _process(_delta):
	if (spawned_zombie_count < Globals.max_zombies) and can_spawn:
		spawn_zombies()
	#when zombies killed equals max for level, initiate new level procedure
	if Globals.killed_during_level == Globals.max_zombies:
		Globals.killed_during_level = 0
		$BetweenRoundTimer.start()
	
		
func _on_between_round_timer_timeout():
	spawned_zombie_count = 0
	#increas max zombies to make rounds harder
	#in future, consider using other zombie resources that have been created
	#randomly assign zombie resources with weights on how often they should spawn based on level
	Globals.max_zombies += 2
	Globals.current_level += 1

	
#function to add spawn locations for zombies to the game
#when called, func adds indices to be checked for spawning based on visible nodes in spawner group
func set_zombie_spawn_indices():
	#check through all zombie spawners in SpawnLocationGroup Node
	for spawner_index in $SpawnLocationGroup.get_child_count():
		#checks that spanwer is visible -> this only happens when a room is unlocked/purchased
		#starting room is always considered unlocked -> those spawners are always visible
		#also checks that index array does not currently have the idividual index before appending it
		#this prevents weighting some spawners heavier than others unintentionally
		if ($SpawnLocationGroup.get_child(spawner_index).visible == true) and (possible_spawn_indices.has(spawner_index) == false):
			possible_spawn_indices.append(spawner_index)

#when zombie node dies, death signal is emitted
#then the connected spawn money function is called
func spawn_money(pos, value):
	#checks total value of killed zombie and spawns that many coins
	for totalValue in value:
		var coin = animated_coin_scene.instantiate()
		#set new position before adding it to scene tree, this ensures random
		#direction for spawning works
		coin.position = pos
		$MoneyGroup.add_child(coin)
		
		#var stores tilemap position of each dropped coin
		var coin_tile_pos = $NavigationRegion2D/TileMap.local_to_map(coin.position)
		#get atlas coords of tile coin is on. If it's inside the room, atlas coords will be (16,0)
		#if coin is outside room, atlas coords will NOT be (16,0)
		#if atlas coords outside, auto collect
		if $NavigationRegion2D/TileMap.get_cell_atlas_coords(1, coin_tile_pos) != Vector2i(16,0):
			coin.queue_free()
			Globals.total_money += 1
		
			
func spawn_zombies() -> void:
	var zombie = zombie_scene.instantiate() as CharacterBody2D
	#connects zombie death signal to help spawn money in world
	zombie.connect("zombie_killed", spawn_money)
	#1. update zombie position
	#pos is randomly chosen based on available spawn locations
	#these possible positions are updated when player unlocks a new room
	var possible_spawn_index = possible_spawn_indices.pick_random()
	zombie.position = $SpawnLocationGroup.get_child(possible_spawn_index).position
	#set zombie target and resource
	zombie.target = $Player
	zombie.enemy_stats = imported_zombie_resource
	#3. add zombie instance to a Node2D
	$Enemies.add_child(zombie)
	#4 increase total zombies spawned, so game doesn't make too many total
	#also make sure more zombies can't currently spawn immediately
	spawned_zombie_count += 1
	can_spawn = false
	#5 start timer so zombies spawn in succession, not all seemingly at once
	$SpawnTimer.start()
	
func _on_spawn_timer_timeout():
	can_spawn = true

func _on_player_shooting(pos, direction):
	var bullet = bullet_scene.instantiate() as Area2D
	#1. update bullet position
	bullet.position = pos
	bullet.rotation_degrees = rad_to_deg(direction.angle()) + 90
	bullet.direction = direction
	#2. move bullet, done in bullet script
	#3. add bullet instance to a Node2D
	$Projectiles.add_child(bullet)
	#$UI.update_laser_text()


func _on_first_door_update_purchase_text():
	if $UI/MarginContainer/HBoxContainer2/PurchaseTextBox.visible == true:
		$UI/MarginContainer/HBoxContainer2/PurchaseTextBox.visible = false
	elif $UI/MarginContainer/HBoxContainer2/PurchaseTextBox.visible == false:
		$UI/MarginContainer/HBoxContainer2/PurchaseTextBox.visible = true

func _on_first_door_door_opened():
	$SpawnLocationGroup/ZombieSpawnLocation5.visible = true
	$SpawnLocationGroup/ZombieSpawnLocation6.visible = true
	set_zombie_spawn_indices()

func _on_second_door_update_purchase_text():
	if $UI/MarginContainer/HBoxContainer2/PurchaseTextBox.visible == true:
		$UI/MarginContainer/HBoxContainer2/PurchaseTextBox.visible = false
	elif $UI/MarginContainer/HBoxContainer2/PurchaseTextBox.visible == false:
		$UI/MarginContainer/HBoxContainer2/PurchaseTextBox.visible = true

func _on_second_door_door_opened():
	$SpawnLocationGroup/ZombieSpawnLocation7.visible = true
	$SpawnLocationGroup/ZombieSpawnLocation8.visible = true
	$SpawnLocationGroup/ZombieSpawnLocation9.visible = true
	set_zombie_spawn_indices()
