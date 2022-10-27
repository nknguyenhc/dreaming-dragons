extends Node
const Level1 = preload("res://Scenes/Level1.tscn")
var lvl1 = Level1.instance()
var intro_tutorial_done = false
var jump_kick_tutorial_done = false
var climb_tutorial_done = false

func _ready():
	lvl1.game = self
	add_child(lvl1)


func restart():
	remove_child(lvl1)
	lvl1 = Level1.instance()
	lvl1.game = self
	lvl1.slime_count = 7
	add_child(lvl1)
