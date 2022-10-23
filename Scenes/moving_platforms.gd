extends KinematicBody2D

## MOVING Platform, med length, horizontal

var init_x = position.x
var init_y = position.y
var speed = 100
var t = 0
var max_t = 2
var dir = 1
var is_vertical = false

func _process(delta):
	if is_vertical:
		position.y = init_y + t * speed * dir
	else:
		position.x = init_x + t * speed* dir
	t += delta
	if t > max_t:
		init_x = position.x
		init_y = position.y
		dir *= -1
		t = 0
