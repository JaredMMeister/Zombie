extends StaticBody2D

var window_invincible: bool = false
var window_health: int = 3

func update_window_health():
	if window_invincible == false:
		window_invincible = true
		window_health -= 1
		$WindowIFrames.start()
	
	#if statements determine how many wood barriers are visible depending on window health
	if window_health == 3:
		$MiddleWood.visible = true
		$LeftWood.visible = true
		$RightWood.visible = true
		#sets collision back to fixed windows
		$".".set_collision_layer_value(6, true)
		$".".set_collision_layer_value(7, false)
	if window_health == 2:
		$MiddleWood.visible = false
	if window_health == 1:
		$LeftWood.visible = false
	if window_health == 0:
		$RightWood.visible = false
		#sets collision to broken windows
		$".".set_collision_layer_value(6, false)
		$".".set_collision_layer_value(7, true)
		

func _on_window_i_frames_timeout():
	window_invincible = false
