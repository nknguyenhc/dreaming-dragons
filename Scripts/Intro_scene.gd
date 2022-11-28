extends Node


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


func _ready():
	dialog = Dialogic.start("intro")
	add_child(dialog)
	dialog.connect("dialogic_signal", self, "signal_handler")
	
	dragon = get_node("Dragon")


func signal_handler(arg):
	if arg == "dragon_appear":
		dragon_fly = true
	if arg == "start_game":
		print("start game")
		game.start_from_title_scene(mode)
		queue_free()


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
