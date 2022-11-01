extends StaticBody2D

var is_used = false


func _on_RecoverBox_body_entered(body):
	if body.name == "Player" and not is_used:
		is_used = true
		if get_parent().get_parent().get_node("Player").health < get_parent().get_parent().get_node("Player").MAX_HEALTH / 5 * 4:
			get_parent().get_parent().get_node("Player").health += get_parent().get_parent().get_node("Player").MAX_HEALTH / 5
		else:
			get_parent().get_parent().get_node("Player").health = get_parent().get_parent().get_node("Player").MAX_HEALTH
			get_node("AnimatedSprite").animation = "open"
		get_node("heal").play()	
		get_node("timer").start()


func _on_timer_timeout():
	queue_free()
