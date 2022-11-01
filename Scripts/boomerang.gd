extends Area2D


var INITIAL_SPEED = 2.2

const FRICTION = 0.03
const GRAVITY = 1
const TERMINAL_V = 3
const MAX_V = 100

const SCALE = 6

var speed
var velocity
var direction

var player

var platform_hit = false
var flying_off = false
const DELAY_TIME = 0.05
var ground_hit = false
var player_hit = false
const EXIST_TIME = 10 # do not allow the boomerang to exist in the scene for too long

var hit_free = false
var hit_free_ground = false
const HIT_FREE_TIME = 0.02 # in case the boomerang hits two tilemaps at the same time

const DAMAGE = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	if get_parent().get_node("dragon").is_boss_fight_started:
		INITIAL_SPEED = 3
	speed = INITIAL_SPEED
	velocity = direction * speed
	scale.x = SCALE
	scale.y = SCALE
	get_node("ExistTimer").start(EXIST_TIME)


func hit_player():
	player_hit = true
	velocity = Vector2.ZERO


func _physics_process(delta):
	if platform_hit or ground_hit:
		pass
	elif player_hit or flying_off:
		if velocity.y < TERMINAL_V:
			velocity.y += GRAVITY
		position += velocity
	else:
		position += velocity
		velocity -= direction * FRICTION
		if abs(velocity.x) > MAX_V:
			velocity.x = velocity.x / abs(velocity.x) * MAX_V
		if abs(velocity.y) > MAX_V:
			velocity.y = velocity.y / abs(velocity.y) * MAX_V


func _on_ReturnDelay_timeout():
	platform_hit = false
	flying_off = true


func _on_Boomerang_body_entered(body):
	if body.get_collision_layer() == 2:
		velocity /= 1.5
		body.health -= DAMAGE
		player.get_node("boomerang_hit").play()


func _on_ExistTimer_timeout():
	player.boomerang_returned = true
	player.on_boomerang = true
	player.player_boomerang()


func _on_HitFreeTimer_timeout():
	hit_free = false
	hit_free_ground = false


func hitting_platform(body, top): # top is a boolean value
	if body.get_collision_layer() == 4: # to be changed later, take the class_name of the body
		if not hit_free and not hit_free_ground:
			if top:
				velocity.y = -velocity.y
			else:
				velocity.x = -velocity.x
			platform_hit = true
			get_node("ReturnDelay").start(DELAY_TIME)
			hit_free = true
			get_node("HitFreeTimer").start(HIT_FREE_TIME)


func hitting_ground(body):
	if body.name == "TileMap" or body.name == "TileMap2" or body.name == "block": # to be changed later, take the class_name of the body
		if not hit_free_ground:
			ground_hit = true
			velocity = Vector2.ZERO
			hit_free = true
			hit_free_ground = true
			get_node("HitFreeTimer").start(HIT_FREE_TIME)
			# hit the player if the player is at where the boomerang falls
			var overlapping_bodies = get_overlapping_bodies()
			if player in overlapping_bodies:
				hit_player()
				player.take_damage(DAMAGE)


func _on_Top_body_entered(body):
	hitting_platform(body, true)


func _on_Left_body_entered(body):
	hitting_platform(body, false)


func _on_Bottom_body_entered(body):
	hitting_ground(body)


func _on_Right_body_entered(body):
	hitting_platform(body, false)
