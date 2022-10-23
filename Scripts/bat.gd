extends KinematicBody2D

# Bat asset source: https://jumelord.itch.io/bat

#var velocity = Vector2.ZERO
var t = 0
var rng = RandomNumberGenerator.new()
var add_on = 0
var health = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	t += delta
	position.x += 5 * sin(t + add_on)
	position.y += 1 * cos(t + add_on)
	if health <= 0:
		queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.take_damage(7)
