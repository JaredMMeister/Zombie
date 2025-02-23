extends CanvasLayer

@onready var health_bar: ProgressBar = %HealthBar
@onready var ammo_bar: ProgressBar = %AmmoBar
#@onready var grenade_label: Label = $GrenadeCounter/VBoxContainer/Label
#@onready var laser_icon: TextureRect = $LaserCounter/VBoxContainer/TextureRect
#@onready var grenade_icon: TextureRect = $GrenadeCounter/VBoxContainer/TextureRect


func _ready():
	Globals.connect("stat_change", update_stat_text)
	update_stat_text()
	
	
	
	
func update_stat_text():
	update_ammo_text()
	update_health_text()
	update_level_text()
	update_money_text()

func update_level_text():
	%LevelLabel.text = str(Globals.current_level)

func update_money_text():
	%MoneyLabel.text = str(Globals.total_money)

func update_ammo_text():
	if Globals.current_bullets > 6:
		Globals.current_bullets = 6
	ammo_bar.value = Globals.current_bullets
	#when player is out of ammo, need to reload
	#in future, wait time of timer should change based on given weapon being used	
	if Globals.current_bullets == 0:
		%AmmoRefillTimer.start()
		Globals.is_reloading = true

func update_health_text():
	if Globals.player_health > 60:
		Globals.player_health = 60
	health_bar.value = Globals.player_health


#starts timer -> current wait time is .2 seconds
#timer allows us to gradually refill ammo progress bar
func _on_ammo_refill_timer_timeout():
	Globals.current_bullets += 1
	#if less than full during reload process, player cannot shoot
	#also restarts the timer to keep ammo bar refilling
	#current max is 6, but should be adjusted in future for better weapons
	if Globals.current_bullets < 6:
		Globals.can_shoot = false
		%AmmoRefillTimer.start()
	#if ammo is max, then player can shoot again.
	else:
		Globals.can_shoot = true
		Globals.is_reloading = false
	
