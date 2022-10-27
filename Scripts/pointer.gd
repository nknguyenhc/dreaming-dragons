extends Node2D


# Declare member variables here. Examples:
var direction
var angle
var RADIUS
var down_strength
var right_strength
const ANGULAR_SPEED = 0.05
var sprite
const Boomerang = preload("res://Scenes/boomerang.tscn")
var player

var key # the key that activated the boomerang


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("Sprite")
	direction = sprite.position
	angle = Vector2.RIGHT.angle_to(direction)
	RADIUS = sqrt(pow(direction.x, 2) + pow(direction.y, 2))
	scale.x = get_parent().get_node("Player").SCALE
	scale.y = get_parent().get_node("Player").SCALE


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if Input.is_action_pressed(key):
		down_strength = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		right_strength = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		# divide into eight sectors, calculate the new angle
		if down_strength > 0:
			if right_strength > 0: # tend towards PI/4
				if -3 * PI / 4 < angle and angle < PI / 4:
					angle += ANGULAR_SPEED
				elif angle == PI / 4:
					pass
				else:
					angle -= ANGULAR_SPEED
			elif right_strength == 0: # tend towards PI/2
				if direction.x >= 0:
					angle += ANGULAR_SPEED
				else:
					angle -= ANGULAR_SPEED
			else: # tend towards 3 PI/4
				if -PI / 4 < angle and angle < 3 * PI / 4:
					angle += ANGULAR_SPEED
				elif angle == 3 * PI / 4:
					pass
				else:
					angle -= ANGULAR_SPEED
		elif down_strength == 0:
			if right_strength > 0: # tend towards 0
				if direction.y >= 0:
					angle -= ANGULAR_SPEED
				else:
					angle += ANGULAR_SPEED
			elif right_strength == 0:
				pass
			else:
				if direction.y >= 0: # tend towards PI
					angle += ANGULAR_SPEED
				else:
					angle -= ANGULAR_SPEED
		else:
			if right_strength > 0: # tend towards -PI/4
				if -PI / 4 < angle and angle < 3 * PI / 4:
					angle -= ANGULAR_SPEED
				elif angle == -PI / 4:
					pass
				else:
					angle += ANGULAR_SPEED
			elif right_strength == 0: # tend towards -PI/2
				if direction.x >= 0:
					angle -= ANGULAR_SPEED
				else:
					angle += ANGULAR_SPEED
			else: # tend towards -3 PI/4
				if - 3 * PI / 4 < angle and angle < PI / 4:
					angle -= ANGULAR_SPEED
				elif angle == -3 * PI / 4:
					pass
				else:
					angle += ANGULAR_SPEED
		
		# with the new angle, reposition the sprite
		sprite.position.x = RADIUS * cos(angle)
		sprite.position.y = RADIUS * sin(angle)
		direction = sprite.position
		angle = Vector2.RIGHT.angle_to(direction)
		sprite.rotation_degrees = rad2deg(angle)
	
	else: # when the player releases the key, unfreeze the scene, make this pointer vanish and unleash the boomerang
		player = get_parent().get_node("Player")
		get_parent().get_tree().paused = false
		player.boomerang = Boomerang.instance()
		player.boomerang.direction = direction
		player.boomerang.position = position
		get_parent().add_child(player.boomerang)
		player.get_node("boomerang_throw").play()
		queue_free()
