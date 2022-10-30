extends StaticBody2D

func _process(delta):
	pass


func _on_RecoverBox_body_entered(body):
	if body.name == "Player":
		get_node("AnimatedSprite").animation = "open"
		get_node("timer").start()


func _on_timer_timeout():
	if get_parent().get_node("Player").health < get_parent().get_node("Player").MAX_HEALTH / 4 * 3:
		get_parent().get_node("Player").health += get_parent().get_node("Player").MAX_HEALTH / 4
	else:
		get_parent().get_node("Player").health = get_parent().get_node("Player").MAX_HEALTH
	queue_free()
