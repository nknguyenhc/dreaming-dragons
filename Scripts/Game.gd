extends Node
const Level1 = preload("res://Scenes/Level1.tscn")
var lvl1
const Modes = preload("res://Scenes/ModeSelection.tscn")
var modes
var intro_tutorial_done = false
var jump_kick_tutorial_done = false
var climb_tutorial_done = false
const sword_respawn_pos = Vector2(-1450, -400)
const boomerang_respawn_pos = Vector2(1250, 0)

var boomerang = false
var sword = false
var player

var cur_mode = "Medium"

func _ready():
	modes = Modes.instance()
	add_child(modes)

func start_from_title_scene(mode):
	lvl1 = Level1.instance()
	lvl1.game = self
	player = lvl1.get_node("Player")
	lvl1.slime_count = 7
	if boomerang == true:
		player.boomerang_collected = true
		player.sword_collected = true
		player.position = boomerang_respawn_pos
		lvl1.get_node("Map1").get_node("BoomerangCollectible").queue_free()
		lvl1.get_node("Map1").get_node("SwordCollectible").queue_free()
	elif sword == true:
		player.sword_collected = true
		player.position = sword_respawn_pos
		lvl1.get_node("Map1").get_node("SwordCollectible").queue_free()
	
	if mode == "Medium":
		cur_mode = "Medium"
		gn("Player").MAX_HEALTH = 200
		gn("slime9").health = 5	
		gn("slime10").queue_free()
		gn("slime11").queue_free()
		gn("slime12").health = 5
		gn("Map1").get_node("spike4").queue_free()
		gn("Map1").get_node("spike6").queue_free()
		gn("Map1").get_node("spike8").queue_free()
		
	elif mode == "Hard":
		cur_mode = "Hard"
		gn("Player").MAX_HEALTH = 150
		gn("greenslime3").position.x += 10
		gn("slime9").health = 5	
		gn("slime10").health = 5
		gn("slime11").health = 5
		gn("slime12").health = 5
	elif mode == "Asian":
		cur_mode = "Asian"
		gn("Player").MAX_HEALTH = 100
		gn("greenslime3").position.x += 30
		gn("slime9").health = 10
		gn("slime10").health = 10
		gn("slime11").health = 10
		gn("slime12").health = 10
		pass
	add_child(lvl1)

func gn(s):
	return lvl1.get_node(s)

func restart_from_last_save_point():
	if player.boomerang_collected == true:
		boomerang = true
	elif player.sword_collected == true:
		sword = true
	remove_child(lvl1)
	start_from_title_scene(cur_mode)

func restart_from_mode_selection():
	for child in get_children():
		if child.name != "BugTimer":
			child.queue_free()
	modes = Modes.instance()
	add_child(modes)
	get_node("BugTimer").start()

func _on_BugTimer_timeout(): # because "queue_free" takes time, cannot initiate right after it
	intro_tutorial_done = false
	jump_kick_tutorial_done = false
	climb_tutorial_done = false
	boomerang = false
	sword = false
