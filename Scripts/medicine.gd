extends StaticBody2D

var is_used = false
var dragon

func _ready():
	dragon = get_parent().get_parent().get_node("dragon")

func _on_RecoverBox_body_entered(body):
	if body.name == "Player" and not is_used:
		is_used = true
		if body.health < body.MAX_HEALTH / 5 * 4:
			body.health += body.MAX_HEALTH / 5
		else:
			body.health = body.MAX_HEALTH
		get_node("AnimatedSprite").animation = "open"
		get_node("heal").play()	
		get_node("timer").start()
		
		if dragon.is_boss_fight_started:
			dragon.is_medicine_exist = false
			
	elif body.name == "dragon" and not is_used:
		is_used = true
		body.health = min(body.health + 20, 100)
		get_node("AnimatedSprite").animation = "open"
		get_node("heal").play()	
		get_node("timer").start()
		
		if dragon.is_boss_fight_started:
			dragon.is_medicine_exist = false


func _on_timer_timeout():
	queue_free()
