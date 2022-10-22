extends KinematicBody2D

# Bat asset source: https://jumelord.itch.io/bat

#var velocity = Vector2.ZERO
var t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	t += delta
	position.x = 200 * sin(t*2) + 500
	position.y = 40 * cos(t*2) - 200

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.health -= 7
	if body.name == "boomerang":
		queue_free()
