extends Area2D


const ANGULAR_V = PI / 25
var swing_angle
var total_swing = 0
var player
var right

const DAMAGE = 5


func _ready():
	player = get_parent()
	if right:
		scale.x = player.SCALE
	else:
		scale.x = -player.SCALE
	scale.y = player.SCALE


func _physics_process(delta):
	if total_swing < rad2deg(swing_angle):
		if right:
			rotation_degrees += rad2deg(ANGULAR_V)
		else:
			rotation_degrees -= rad2deg(ANGULAR_V)
		total_swing += rad2deg(ANGULAR_V)
	else:
		player.end_sword()
		queue_free()


func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 2 or body.get_collision_layer() == 16:
		body.health -= DAMAGE
		if body.get_collision_layer() == 16:
			player.get_node("leaf_hurt").play()
		else:
			player.get_node("sword_hit").play()
