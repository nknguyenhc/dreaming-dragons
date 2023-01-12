extends Node2D


var dialog
var dialog1
var mode
var game

var dragon
var dragon_fly = false
var fly_state_activated = false
var fly_count = 0
const dragon_speed = 5
const left_pos = 300
const right_pos = 1000
const extreme_right = 1800
var spitting_fire = false
var fire_state_activated = false
const firetime = 2.5
var idle = false
var idle_state_activated = false
const idletime = 0.5

var state = 1
var state1 = 1
var state2 = 1
var fires = []
const fire_waittime = 1

var disappearing = false
const decrease = 0.05


func _ready():
	# hide all the fire animations
	for child in get_children():
		if child is AnimatedSprite and child.name != "Dragon":
			fires.append(child)
	for fire in fires:
		fire.hide()
	
	dialog = Dialogic.start("intro")
	add_child(dialog)
	dialog.connect("dialogic_signal", self, "signal_handler")
	
	dragon = get_node("Dragon")


func signal_handler(arg):
	if arg == "dragon_appear":
		dragon_fly = true
	if arg == "start_game":
		disappearing = true


func _physics_process(delta):
	if dragon_fly:
		if not fly_state_activated:
			dragon.play("fly")
			fly_state_activated = true
		dragon.position.x += dragon_speed
		if (fly_count == 0 and dragon.position.x > left_pos) or (fly_count == 1 and dragon.position.x > right_pos):
			idle = true
			dragon_fly = false
			fly_state_activated = false
			get_node("IdleTimer").start(idletime)
		if dragon.position.x > extreme_right:
			dragon_fly = false
			dialog1 = Dialogic.start("intro1")
			dialog1.connect("dialogic_signal", self, "signal_handler")
			add_child(dialog1)
	elif idle:
		if not idle_state_activated:
			dragon.play("idle")
			idle_state_activated = true
	elif spitting_fire:
		if not fire_state_activated:
			dragon.play("fire")
			fire_state_activated = true
	
	if disappearing:
		self.modulate.r -= decrease
		self.modulate.g -= decrease
		self.modulate.b -= decrease
		if self.modulate.r < decrease:
			game.start_from_title_scene(mode)
			queue_free()


func _on_FireTimer_timeout():
	spitting_fire = false
	dragon_fly = true
	fire_state_activated = false
	fly_count += 1


func _on_IdleTimer_timeout():
	spitting_fire = true
	idle = false
	idle_state_activated = false
	get_node("FireTimer").start(firetime)
	get_node("FireSpreading" + str(state)).start(fire_waittime)
	state += 1


func _on_FireSpreading1_timeout():
	var key = "Fire1" + str(state1)
	for fire in fires:
		if key in fire.name:
			fire.play()
			fire.show()
	state1 += 1


func _on_FireSpreading2_timeout():
	var key = "Fire2" + str(state2)
	for fire in fires:
		if key in fire.name:
			fire.play()
			fire.show()
	state2 += 1
