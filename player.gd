extends CharacterBody2D

signal shooting(pos, direction)

var player_health: int = 5
const base_speed: int = 48
#use speed modifier variable to change speed with upgrades?
var speed_modifier: int = 1
var new_speed: float = base_speed * speed_modifier
#var can_shoot: bool = true


func _process(_delta):
	#player input to move character
	var direction  = Input.get_vector("left","right","up","down")
	velocity = direction * new_speed
	move_and_slide()

	
	#reload action when player presses 'r' key
	#sets bullets to zero which is requirement for reload ammo function to be called
	#in UI and within globals script
	if Input.is_action_just_pressed("reload"):
		Globals.can_shoot = false
		Globals.current_bullets = 0
	
	#rotate gun and look at mouse
	$Gun.look_at(get_global_mouse_position())
	#Get vector that gun is pointing in to use later for emitting bullets
	var gun_direction = (get_global_mouse_position() - position).normalized()
	#flip sprite of gun when rotating around player
	if gun_direction.x < 0:
		$Gun.flip_v = true
	else:
		$Gun.flip_v = false
		
		
	#player shooting input
	if Input.is_action_pressed("Shoot") and Globals.can_shoot == true:
		#signal to tell level script position and direction bullet needs to be
		#instantiated from. Bullet script handles movement, level script handles
		#instantiating bullet scene
		shooting.emit($Gun/Marker2D.global_position, gun_direction)
		Globals.current_bullets -= 1
		Globals.can_shoot = false
		$ShootingTimer.start()
		

func hit():
	#on hit from zombie, check to see if player has half second i-frame
	if Globals.invincible == false:
		#if they do not have half second i-frame, lose 10 health from hit.
		Globals.player_health -= 10
		#set i-frame to true so the player doesn't take dmg for 1 second.
		Globals.invincible = true
		#timer used to create i-frame
		$HitTimer.start()

#after half second, times out, then player no longer has i-frame
func _on_hit_timer_timeout():
	Globals.invincible = false

#after half second, allow player to shoot again given that they are not reloading
func _on_shooting_timer_timeout():
	if (Globals.current_bullets > 0) and (Globals.is_reloading == false):
		Globals.can_shoot = true
