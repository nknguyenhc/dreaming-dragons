extends KinematicBody2D


# Declare member variables here. Examples:
var gravity = 40
var velocity = Vector2(0, -700)
var health = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity
	move_and_slide(velocity, Vector2.UP)	
	if is_on_floor():
		velocity = Vector2(0, -700)
	if health == 0:
		queue_free()


func _on_Hurtbox_body_entered(body):
	if body.name == "Player":
		body.health -= 3
	if body.name == "boomerang":
		health -= 5
	if body.name == "kick":
		health -= 10
