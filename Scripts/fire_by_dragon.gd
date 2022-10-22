extends Area2D


const SCALE = 4

var velocity
const SPEED = 2

# during flight
var direction # only used if the fire ball is travelling in mid air
var landed # will be set to true once the fireball hits ground
const marker = -950

# during spreading
var next_fire_ball
var next_fire_ball2
var direction_of_spread # both or left or right
const SPACE_IN_BETWEEN = 10
const WAIT_TIME = 1
var fire_spread = false # set to true when two fire balls next to it have appeared
var rotate_direction = false # set to true if the side hits a wall
var test_list

var player
var dragon


#start 2 timers


#the static body come with sprite and hurtbox.
#end this loop when time is up on timer 1 (burn_time).
#remove the instances of burnt ground when time is up on timer 2 (hurt_stay_time)



func _ready():
	if direction_of_spread == "both":
		scale.x = SCALE
		scale.y = SCALE
	if not landed:
		direction = player.position - position
		velocity = Vector2.ZERO
		velocity.x = direction.x / sqrt(pow(direction.x, 2) + pow(direction.y, 2)) * SPEED
		velocity.y = direction.y / sqrt(pow(direction.x, 2) + pow(direction.y, 2)) * SPEED
	if rotate_direction:
		print("rotate direction true!")


func _physics_process(delta):
	if not landed:
		if position.y > marker:
			get_node("Bottom").set_collision_mask_bit(2, true)
		position += velocity
	else:
		if not fire_spread:
			next_fire_ball = dragon.FireBall.instance()
			next_fire_ball.player = player
			next_fire_ball.dragon = dragon
			next_fire_ball.landed = true
			if direction_of_spread == 'both':
				next_fire_ball.direction_of_spread = "right"
				next_fire_ball.position.x = SPACE_IN_BETWEEN
				next_fire_ball2 = dragon.FireBall.instance()
				next_fire_ball2.player = player
				next_fire_ball2.dragon = dragon
				next_fire_ball2.landed = true
				next_fire_ball2.direction_of_spread = "left"
				next_fire_ball2.position.x = -SPACE_IN_BETWEEN
			else:
				next_fire_ball.direction_of_spread = direction_of_spread
				if direction_of_spread == "left":
					next_fire_ball.position.x = -SPACE_IN_BETWEEN
					test_list = get_node("Left").get_overlapping_bodies()
					if len(test_list) > 0 and (test_list[0].name == "TileMap" or test_list[0].name == "TileMap2"):
						rotate_direction = true
				else:
					next_fire_ball.position.x = SPACE_IN_BETWEEN
			fire_spread = true
			get_node("WaitTimer").start(WAIT_TIME)


func _on_Left_body_entered(body):
	if body.name == "TileMap" or body.name == 'TileMap2':
		if direction_of_spread == 'left' or direction_of_spread == 'both':
			rotate_direction = true


func _on_Right_body_entered(body):
	if body.name == "TileMap" or body.name == 'TileMap2':
		if direction_of_spread == 'right' or direction_of_spread == 'both':
			rotate_direction = true


func _on_WaitTimer_timeout():
	add_child(next_fire_ball)
	if direction_of_spread == 'both':
		add_child(next_fire_ball2)


func _on_Bottom_body_entered(body):
	if body.name == "TileMap" or body.name == "TileMap2":
		landed = true
		print("landed")
