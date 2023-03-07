extends Node2D
var game
const Intro = preload("res://Scenes/Intro.tscn")
var intro

var mode
var disappearing = false
const decrease = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_parent()


func _physics_process(delta):
	if disappearing:
		self.modulate.r -= decrease
		self.modulate.g -= decrease
		self.modulate.b -= decrease
		if self.modulate.r < decrease:
			pressed(mode)
			queue_free()


func _on_Medium_pressed():
	mode = "Medium"
	disappearing = true


func _on_Hard_pressed():
	mode = "Hard"
	disappearing = true


func _on_Asian_pressed():
	mode = "Asian"
	disappearing = true


func pressed(mode):
	game.start_from_title_scene(mode)
