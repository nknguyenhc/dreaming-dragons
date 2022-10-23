extends Area2D


func _on_unclimable_body_entered(body):
	if body.name == "Player":
		print(123)
		body.can_climb = false

func _on_unclimable_body_exited(body):
	if body.name == "Player":
		body.can_climb = true
