extends Camera2D


var velocity = Vector2.ZERO
var current_pos #current position
var final_pos = Vector2(3750, -1280) #final position
var rate = 20 #moving rate
var camera_moving_to_boss_fighting = true
var flag = true
var dx
var dy
var t = 0
var timeout
var count = 10

var dragon
var player
var background

# Called when the node enters the scene tree for the first time.
func _ready():
	dragon = get_parent().get_parent().get_node("dragon")
	player = get_parent().get_parent().get_node("Player")
	background = get_parent().get_node("Background")
	position = player.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += 1
	if dragon.is_boss_fight_started == false:
		if player.position.x - position.x > 300:
			global_position.x = player.global_position.x - 300
		if player.position.x - position.x < -300:
			global_position.x = player.global_position.x + 300
		if player.position.y - position.y > 150:
			global_position.y = player.global_position.y - 150
		if player.position.y - position.y < -150:
			global_position.y = player.global_position.y + 150	
		background.position = position * 0.96
	
	elif camera_moving_to_boss_fighting == true:
		get_parent().get_node("block").get_node("collision").disabled = false
		current_pos = position
		dx = (final_pos.x - current_pos.x) / rate
		dy = (final_pos.y - current_pos.y) / rate
		position += Vector2(dx, dy)
		get_node("Player Health").visible = false
		zoom = Vector2(1.5,1.5)
		background.scale = Vector2(1.5 / 1.2, 1.5 / 1.2)
		background.position = position# + accumulated_pos_change
		if abs(position.x - final_pos.x) < 1:
#			if flag == true:
#				zoomin()
			camera_moving_to_boss_fighting = false
			get_node("Player Health").rect_position.y -= 87
			get_node("Player Health").rect_position.x -= 250
			get_node("Player Health").visible = true
			

 

#func zoomin():
#	if count > 0:
#		zoom -= Vector2(0.2,0.2)
#		count -= 1
#		get_parent().get_node("zoom_timer").start()
#
#func _on_zoom_time_timeout():
#	zoomin()
