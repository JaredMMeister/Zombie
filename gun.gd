extends Sprite2D

@export var gun_stats: Resource

func _ready():
	$".".texture = gun_stats.find_texture()
	#sets initial gun damage for starting gun resource
	gun_stats.find_gun_damage()
