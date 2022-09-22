extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity
var speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = (get_parent().get_node("player").position - position).normalized() * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += velocity


func _on_burn_time_timeout():
	queue_free()


func _on_fire_box_body_entered(body):
	if body.name == "player":
		body.health -= 1
	#if body.name == "map1":
		#burn the ground to a certain distance

