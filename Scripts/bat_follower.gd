extends KinematicBody2D

var speed = 2
var flag = true
var timeout = false

func _ready():
	pass

func _physics_process(delta):
	if get_parent().slime_count <= 0:
		if flag == true:
			get_node("Timer").start()
			flag = false
		elif timeout == true:
			position.x = move_toward(position.x, get_parent().get_node("Player").position.x, speed)
			position.y = move_toward(position.y, get_parent().get_node("Player").position.y, speed)


func _on_Hurtbox_body_entered(body):
	if body.name == "Player":
		body.take_damage(7)


func _on_Timer_timeout():
	timeout = true
