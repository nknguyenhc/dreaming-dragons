extends Area2D


# Declare member variables here. Examples:
const INITIAL_SPEED = 40
const FRICTION = 1
const VELOCITY_LIMIT = -80
var velocity
var direction

const DAMAGE = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = direction * INITIAL_SPEED


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func disappear():
	queue_free()


func _physics_process(delta):
	position += velocity
	velocity.x -= FRICTION
	if velocity.x < VELOCITY_LIMIT:
		disappear()
