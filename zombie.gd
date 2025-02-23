extends CharacterBody2D

signal zombie_killed(pos, value)

#uses custom zombie_resource to get stats for different types of zombies
@export var enemy_stats: Resource
@export var target: CharacterBody2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var direction = Vector2.ZERO
var zombie_health: int
var zombie_value: int



func _ready():
	set_modulate(enemy_stats.find_color())
	$Sprite2D.texture = enemy_stats.find_texture()
	zombie_value = enemy_stats.find_value()
	zombie_health = enemy_stats.health
	

func _physics_process(delta):
	direction = (navigation_agent_2d.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * enemy_stats.zombie_speed, delta)
	
	move_and_collide(velocity * delta)
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().has_method("hit"):
			#could pass value in hit function for zombies with different dmgs to player
			#then player uses passed value to update health based on different dmg
			collision.get_collider().hit()
		#if zombie is colliding with window, tells window to update its health
		if collision.get_collider().has_method("update_window_health"):
			collision.get_collider().update_window_health()
	#if zombie health is hits zero, they die
	if zombie_health <= 0:
		#lets others know that zombie died and how much value they were worth
		zombie_killed.emit(position, zombie_value)
		Globals.killed_during_level += 1
		queue_free()

#when zombie hit by bullet, reduce health by current gun's dmg
func bullet_hit():
	zombie_health -= Globals.current_gun_damage

#resets zombie nav path, so they start looking for player quicker every frame
func _on_nav_timer_timeout():
	navigation_agent_2d.target_position = target.global_position

