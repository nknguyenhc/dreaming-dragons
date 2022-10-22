extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2.ZERO
var current_pos #current position
var final_pos = Vector2(3700, -1280) #final position
var rate #moving rate
var camera_moving_to_boss_fighting = true
var flag = true
var dx
var dy
var scale_d
var factor

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
		if (flag == true):
			factor = rate / current_pos.x
			flag = false
		current_pos = position
		dx = move_toward(current_pos.x, final_pos.x, rate)
		dy = move_toward(current_pos, final_pos, rate)
		position += Vector2(dx, dy)
		scale_d = move_toward(1, 1.5, factor * 0.5)
		scale.x = scale_d
		scale.y = scale_d
		if (current_pos.x - position.x < rate):
			camera_moving_to_boss_fighting = false
	

