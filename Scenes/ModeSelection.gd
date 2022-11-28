extends Node2D
var game
const Intro = preload("res://Scenes/Intro.tscn")
var intro

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_parent()


func _on_Medium_pressed():
	pressed("Medium")
	queue_free()


func _on_Hard_pressed():
	pressed("Hard")
	queue_free()


func _on_Asian_pressed():
	pressed("Asian")
	queue_free()


func pressed(mode):
	intro = Intro.instance()
	intro.mode = mode
	intro.game = game
	game.add_child(intro)
