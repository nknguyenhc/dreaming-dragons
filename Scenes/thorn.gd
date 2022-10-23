extends Area2D

var is_damaging = false

func _physics_process(delta):
	if is_damaging:
		get_parent().get_parent().get_node("Player").take_damage(30)


func _on_thorn_body_entered(body):
	is_damaging = true
		



func _on_thorn_body_exited(body):
	if body.name == "Player":
		is_damaging = false
		
