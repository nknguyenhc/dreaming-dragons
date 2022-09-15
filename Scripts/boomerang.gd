extends Area2D


# Declare member variables here. Examples:
const INITIAL_SPEED = 200
const FRICTION = 10
var velocity
var direction


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = direction * INITIAL_SPEED


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func disappear():
	queue_free()


func _physics_process(delta):
	velocity.x -= FRICTION
	position += velocity
