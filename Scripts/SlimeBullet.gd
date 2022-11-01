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
	if dir == Vector2.ZERO:
		dir = Vector2(1,0)
	if get_parent().get_parent().cur_mode == "Medium":
		speed = 250
	elif get_parent().get_parent().cur_mode == "Hard":
		speed = 350
	else:
		speed = 500

func _process(delta):
	position += dir * speed * delta


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.take_damage(damage)
