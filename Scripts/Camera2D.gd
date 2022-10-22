extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2.ZERO
var current_pos #current position
var final_pos = Vector2(3700, -1280) #final position
var rate = 20 #moving rate
var camera_moving_to_boss_fighting = true
var flag = true
var dx
var dy
var t = 0


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
		if (t < 400):
			zoom -= Vector2(0.01,0.01)
		if position.x - final_pos.x > rate:
			camera_moving_to_boss_fighting = false
	

