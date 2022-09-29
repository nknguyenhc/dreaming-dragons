extends StaticBody2D

const HURT_DEGREE = 1

func _on_Hurtbox_body_entered(body):
	if (body.name == "player"):
		body.health -= HURT_DEGREE
