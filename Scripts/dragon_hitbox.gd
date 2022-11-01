extends Area2D


var dragon
var player
var damage


func _ready():
	dragon = get_parent()
	player = dragon.get_parent().get_node("Player")


func _physics_process(delta):
	if dragon.is_death_initiated:
		damage = 0
	elif dragon.current_state == dragon.BOSS_STATE.DASH:
		damage = 15
	elif dragon.current_state == dragon.BOSS_STATE.KICK:
		damage = 20
	elif dragon.stomp_initiated and dragon.delay_timeout:
		damage = 25
	else:
		damage = 6


func _on_Hitbox_body_entered(body):
	player.take_damage(damage)
