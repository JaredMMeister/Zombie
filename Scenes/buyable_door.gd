extends StaticBody2D

signal update_purchase_text()
signal door_opened()
var can_purchase: bool = false

func _process(_delta):
	if can_purchase == true:
		if Input.is_action_just_pressed("interact") and (Globals.total_money >= 20):
			Globals.total_money -= 20
			door_opened.emit()
			queue_free()
	
#only player should trigger this since buyZone can only see player mask
func _on_buy_zone_body_entered(_body):
	can_purchase = true
	update_purchase_text.emit()
	

func _on_buy_zone_body_exited(_body):
	can_purchase = false
	update_purchase_text.emit()
