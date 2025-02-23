extends Area2D

@export var speed: int = 1000
var direction: Vector2 = Vector2.UP

#continually updates bullet position, handling its movement
func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	#when bullet hits something, queue free it
	queue_free()
	#this checks to see if the body entering bullet was an enemy or not
	#if bullet hits zombie, zombie has bullet hit script that will run
	if body.has_method("bullet_hit"):
		body.bullet_hit()
