extends Area2D

var dir
var damage = 8
var speed = 500

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	dir = (get_parent().get_node("Player").position - position).normalized()

func _process(delta):
	position += dir * speed * delta


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.take_damage(damage)
