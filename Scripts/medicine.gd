extends StaticBody2D

var is_used = false
var dragon

func _ready():
	dragon = get_parent().get_parent().get_node("dragon")

func _on_RecoverBox_body_entered(body):
	if body.name == "Player" and not is_used:
		is_used = true
		get_node("AnimatedSprite").animation = "open"
		get_node("heal").play()	
		get_node("timer").start()
		
		if dragon.is_boss_fight_started:
			dragon.is_medicine_exist = false
			body.health = min(body.MAX_HEALTH, body.health + body.MAX_HEALTH / 10)
		else:
			body.health = min(body.MAX_HEALTH, body.health + body.MAX_HEALTH / 5)
			
	elif body.name == "dragon" and not is_used:
		is_used = true
		body.health = min(body.health + 15, 100)
		get_node("AnimatedSprite").animation = "open"
		get_node("heal").play()	
		get_node("timer").start()
		
		if dragon.is_boss_fight_started:
			dragon.is_medicine_exist = false


func _on_timer_timeout():
	queue_free()
