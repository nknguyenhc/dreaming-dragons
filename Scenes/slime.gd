extends KinematicBody2D


# Declare member variables here. Examples:
var gravity = 2
var velocity = Vector2(0, -20)


# Called when the node enters the scene tree for the first time.
func _ready():
	move_and_slide(velocity, Vector2.UP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_on_floor():
		velocity = Vector2(0, -20)
	velocity.y += gravity
	position += velocity
