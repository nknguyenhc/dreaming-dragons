extends Node2D
var game

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_parent()


func _on_Medium_pressed():
	game.start_from_title_scene("Medium")
	queue_free()


func _on_Hard_pressed():
	game.start_from_title_scene("Hard")
	queue_free()


func _on_Asian_pressed():
	game.start_from_title_scene("Asian")
	queue_free()
