extends Area2D


var dragon
var player
var damage


func _ready():
	dragon = get_parent()
	player = dragon.get_parent().get_node("Player")


func _physics_process(delta):
	if dragon.current_state == dragon.BOSS_STATE.DASH:
		damage = 10
	elif dragon.current_state == dragon.BOSS_STATE.KICK:
		damage = 12
	elif dragon.stomp_initiated and dragon.delay_timeout:
		damage = 12
	else:
		damage = 4


func _on_Hitbox_body_entered(body):
	player.take_damage(damage)
