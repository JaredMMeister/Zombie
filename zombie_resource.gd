extends Resource
class_name zombie_type

var green_texture = preload("res://Graphics/zombie.png")
var red_texture = preload("res://Graphics/red_zombie.png")
@export var zombie_texture: Texture2D
@export var type: types
enum types {GREEN,RED}
@export var zombie_speed: int
@export var health: int
@export var money_value: int

func find_color():
	var color: Color
	match type:
		types.GREEN:
			color = Color(0,0.85,0.45,1)
		types.RED:
			color = Color(1,0,0.14,1)
	return color

func find_texture():
	var texture: Texture2D
	match type:
		types.GREEN:
			texture = green_texture
		types.RED:
			texture = red_texture
	return texture
	
func find_value():
	match type:
		types.GREEN:
			money_value = 3
		types.RED:
			money_value = 6
	return money_value
