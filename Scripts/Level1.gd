extends Node2D

var slime_count = 7

var map
var player
var camera
var game

var IntroTutorial = preload("res://Scenes/Intro tutorial.tscn")
var intro_tutorial
const INTRO_DELAY = 0.2
var JumpKickTutorial = preload("res://Scenes/JumpKickTutorial.tscn")
var jump_kick_tutorial
var ClimbTutorial = preload("res://Scenes/climb_tutorial.tscn")
var climb_tutorial


func _ready():
	map = get_node("Map1")
	camera = map.get_node("Camera2D")
	
	get_node("slime9").health = 10	
	get_node("slime10").health = 10
	get_node("slime11").health = 10
	get_node("slime12").health = 10
	get_node("slime9").decrement = 0	
	get_node("slime10").decrement = 0	
	get_node("slime11").decrement = 0
	get_node("slime12").decrement = 0

	get_node("bat2").add_on = 1
	get_node("bat3").add_on = 2
	
	map.get_node("spike5").damage = 30
	map.get_node("spike7").damage = 20
	map.get_node("thorn").damage = 30
	
	map.get_node("mp1-2").max_t = 1.5
	map.get_node("mp2-1").max_t = 1
	map.get_node("mp2-1").speed = 300
	map.get_node("mp3-1").is_vertical = true
	map.get_node("mp3-1").speed = 50
	map.get_node("mp3-2").is_vertical = true
	map.get_node("mp3-2").speed = 50
	map.get_node("mp3-2").max_t = 1.6
	map.get_node("mp3-3").is_vertical = true
	map.get_node("mp3-3").speed = 50
	map.get_node("mp3-3").max_t= 1.8
	map.get_node("mp4-1").speed = 50
	map.get_node("mp4-1").max_t = 1
	map.get_node("mp3-4").speed = 60
	map.get_node("mp3-4").max_t = 2.2
	map.get_node("mp3-4").is_vertical = true
	map.get_node("mp3-5").speed = 50
	map.get_node("mp3-5").is_vertical = true
	map.get_node("mp4-2").speed = 100
	map.get_node("mp4-2").max_t = 11
	map.get_node("mp2-2").speed = 50
	map.get_node("mp2-2").max_t = 20
	
	player = get_node("Player")
	
	if not game.intro_tutorial_done:
		get_node("IntroDelay").start(INTRO_DELAY)


func _process(delta):
	if player.position.x > -3700 and not game.jump_kick_tutorial_done:
		game.jump_kick_tutorial_done = true
		jump_kick_tutorial = JumpKickTutorial.instance()
		camera.add_child(jump_kick_tutorial)
		get_tree().paused = true
	if player.position.x > -2550 and not game.climb_tutorial_done:
		game.climb_tutorial_done = true
		climb_tutorial = ClimbTutorial.instance()
		camera.add_child(climb_tutorial)
		get_tree().paused = true
	
	if slime_count == 0:
		get_node("magic").play()
		get_node("blocking").queue_free()
		slime_count -= 1


func _on_IntroDelay_timeout():
	game.intro_tutorial_done = true
	intro_tutorial = IntroTutorial.instance()
	map.get_node("Camera2D").add_child(intro_tutorial)
	get_tree().paused = true
