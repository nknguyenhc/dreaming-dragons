extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity
var speed = 5
var ground_height  # y-position of platform
var platform_burning = preload("res://Scenes/platform_burning.tscn")
var initial_position   # the x-position where fireball just hit the ground
var initialised = false  # will be set to true once the fireball hits ground
var platform   # instances of platform_burning
var fire_spreading = true
const LENGTH_PER_PLATFORM = 3
const HURT_DEGREE = 1



#start 2 timers


#the static body come with sprite and hurtbox.
#end this loop when time is up on timer 1 (burn_time).
#remove the instances of burnt ground when time is up on timer 2 (hurt_stay_time)



func _ready():
	velocity = (get_parent().get_node("player").position - position).normalized() * speed
	#get y-position of platform(ground)
	ground_height = get_parent().get_node("ground").position.x



func _physics_process(delta):
	if (fire_spreading == true):
		position += velocity
	
		#when the fireball hits the ground (equal y position)
		if position.y == ground_height: # change this to body-entered  # We do this comparison instead of using body_entered because now the position of platfom can be adjusted more accuractely
			velocity.y = 0  #make it move horizontally in the same initial horizontal direction
			if (initialised == false):
				initial_position = position.x  # the x-position where fireball just hit the ground
				initialised = true
		if (position.x - initial_position) % LENGTH_PER_PLATFORM == 0:
			platform = platform_burning.instance()  #create instances of static body of burnt ground along the direction, one frame per unit distance
			platform.position = position
			add_child(platform)


func _on_burn_time_timeout():
	fire_spreading = false


func _on_fire_box_body_entered(body):
	if body.name == "player":
		body.health -= HURT_DEGREE
	#if body.name == "map1":
		#burn the ground to a certain distance

func _on_hurt_stay_time_timeout():
	queue_free()
