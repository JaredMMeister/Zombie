extends Area2D

var animation_can_play: bool = true
var distance: int = randi_range(2, 8)
var random_rotation: int = randi_range(45,135)

func _ready():
	#tween to randomly assign position
	#on spawn, takes random rotation and spins it a bit
	var current_direction: Vector2 = Vector2.DOWN.rotated(random_rotation)
	#set where the coin should end up based on rotation
	var target_pos = position + current_direction * distance
	#use tweens to send coins to target locations nearby spawn
	var tween = create_tween().set_parallel()
	tween.tween_property(self,"position",target_pos, 0.5)
	tween.tween_property(self, "scale", Vector2(1,1),0.3).from(Vector2(0,0))


func _process(_delta):
	if animation_can_play == true:
		animate_coin()

func animate_coin():
	#keeps repeat tween animations from playing
	animation_can_play = false
	#creates tween and binds it to node
	#binding makes sure tween is aborted when node leaves scene tree via queue_free
	#this solves some errors in debugging
	var tween = $".".create_tween()
	tween.tween_property($".", "scale", Vector2(1.2,1.2), .5)
	tween.tween_property($".", "scale", Vector2(.7,.7), .5)
	$AnimationTimer.start()

#helps repeat tween animation every 1 second
func _on_animation_timer_timeout():
	animation_can_play = true

func _on_body_entered(body):
	#checks to make sure player is one picking up coin
	#if statement prevents coin from dissappearing when hitting wall
	if body.name == "Player":
		Globals.total_money += 1
		queue_free()
