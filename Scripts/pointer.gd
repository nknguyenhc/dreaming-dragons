extends Node2D


# Declare member variables here. Examples:
var direction
var angle
var RADIUS
var down_strength
var right_strength
const ANGULAR_SPEED = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	direction = get_node("Sprite").position - position
	angle = Vector2.RIGHT.angle_to(direction)
	RADIUS = sqrt(direction.x ^ 2 + direction.y ^ 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	down_strength = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	right_strength = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# divide into four quadrants
