extends Area2D


const INITIAL_SPEED = 2
const FRICTION = 0.05
const GRAVITY = 1

var speed
var velocity
var direction

var platform_hit = false
const DELAY_TIME = 0.2
var ground_hit = false
var player_hit = false
const GROUND_TIME = 2

const DAMAGE = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	speed = INITIAL_SPEED
	velocity = direction * speed
	scale.x = get_parent().get_node("Player").SCALE
	scale.y = get_parent().get_node("Player").SCALE


func hit_player():
	player_hit = true
	velocity = Vector2.ZERO


func _physics_process(delta):
	if platform_hit or ground_hit:
		pass
	elif player_hit:
		velocity.y += GRAVITY
		position += velocity
	else:
		position += velocity
		velocity -= direction * FRICTION


func _on_Boomerang_body_entered(body):
	if body.get_name() == "obstacle": # to be changed later, take the class_name of the body
		if velocity.y <= 0: # only let the boomerang return when it is travelling up
			velocity = -velocity
			platform_hit = true
			get_node("ReturnDelay").start(DELAY_TIME)
		else:
			ground_hit = true
			if player_hit:
				get_node("OnGroundTimer").start(GROUND_TIME)


func _on_ReturnDelay_timeout():
	platform_hit = false


func _on_OnGroundTimer_timeout():
	get_parent().get_node("Player").player_boomerang()
