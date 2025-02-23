extends Resource

class_name gun_type

var pistol_texture = preload("res://Graphics/pistol.png")
var shotgun_texture = preload("res://Graphics/shotgun.png")
@export var gun_texture: Texture2D
@export var type: types
enum types {PISTOL, SHOTGUN}
@export var damage: int

func find_texture():
	var texture: Texture2D
	match type:
		types.PISTOL:
			texture = pistol_texture
		types.SHOTGUN:
			texture = shotgun_texture
	return texture

#matches gun damage to type that player currently has
#function is called in gun script
func find_gun_damage():
	match type:
		types.PISTOL:
			Globals.current_gun_damage = damage
		types.SHOTGUN:
			Globals.current_gun_damage = damage
	return #Globals.current_gun_damage
