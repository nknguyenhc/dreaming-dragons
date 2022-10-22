extends Node2D

var slime_count = 7

func _ready():
	get_node("bat2").add_on = 1
	get_node("bat3").add_on = 2

func _process(delta):
	if slime_count == 0:
		get_node("blocking").queue_free()
