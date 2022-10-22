extends Camera2D


var velocity = Vector2.ZERO
var current_pos #current position
var final_pos = Vector2(3700, -1280) #final position
var rate = 20 #moving rate
var camera_moving_to_boss_fighting = true
var flag = true
var dx
var dy
var t = 0
var timeout
var count = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += 1
	if get_parent().get_parent().get_node("dragon").is_boss_fight_started == false:
		if get_parent().get_parent().get_node("Player").position.x - position.x > 900:
			global_position.x = get_parent().get_parent().get_node("Player").global_position.x - 900
		if get_parent().get_parent().get_node("Player").position.x - position.x < -900:
			global_position.x = get_parent().get_parent().get_node("Player").global_position.x + 900
		if get_parent().get_parent().get_node("Player").position.y - position.y > 400:
			global_position.y = get_parent().get_parent().get_node("Player").global_position.y - 400
		if get_parent().get_parent().get_node("Player").position.y - position.y < -400:
			global_position.y = get_parent().get_parent().get_node("Player").global_position.y + 400	
	elif camera_moving_to_boss_fighting == true:
		get_parent().get_node("block").get_node("collision").disabled = false
		current_pos = position
		dx = (final_pos.x - current_pos.x) / rate
		dy = (final_pos.y - current_pos.y) / rate
		position += Vector2(dx, dy)
		if position.x - final_pos.x > rate:
#			if flag == true:
#				zoomin()
			camera_moving_to_boss_fighting = false

#func zoomin():
#	if count > 0:
#		zoom -= Vector2(0.2,0.2)
#		count -= 1
#		get_parent().get_node("zoom_timer").start()
#
#func _on_zoom_time_timeout():
#	zoomin()
