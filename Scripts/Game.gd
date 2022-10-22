extends Node
const Level1 = preload("res://Scenes/Level1.tscn")
var lvl1 = Level1.instance()

func _ready():
	add_child(lvl1)


func restart():
	remove_child(lvl1)
	lvl1 = Level1.instance()
	add_child(lvl1)
