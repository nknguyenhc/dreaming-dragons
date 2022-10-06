extends KinematicBody2D


# appearance in the main map
const SCALE = 7

# movement
const GRAVITY = 50
var velocity = Vector2.ZERO
const JUMP_STRENGTH = 3000
const HORIZONTAL_SPEED = 300
const VERTICAL_SPEED = 300

# skills
var player_freeze = false # do not allow the player to move while activating some skills
const Punch = preload("res://Scenes/punch.tscn")
var punch
var punch_enabled = true
const PUNCH_WAIT_TIME = 1
const Kick = preload("res://Scenes/kick.tscn")
var kick
var kick_enabled = true
const KICK_WAIT_TIME = 1
const Boomerang = preload("res://Scenes/pointer.tscn")
var pointer
var boomerang
var freeze = false # freeze the entire scene when activating boomerang
var boomerang_enabled = true
var boomerang_returned = false
var boomerang_thrown = false
var boomerang_key = "ui_skill3"
const BOOMERANG_WAIT_TIME = 0.5

# health
const MAX_HEALTH = 100
var health = MAX_HEALTH
var invincible = false
const INVINCIBILITY_WAIT_TIME = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func player_punch():
	if punch_enabled:
		player_freeze = true
		punch = Punch.instance()
		add_child(punch)
		punch_enabled = false
		get_node("PunchTimer").start(PUNCH_WAIT_TIME)


func player_kick():
	if kick_enabled:
		player_freeze = true
		kick = Kick.instance()
		add_child(kick)
		kick_enabled = false
		get_node("KickTimer").start(KICK_WAIT_TIME)


func player_boomerang():
	if boomerang_enabled:
		pointer = Boomerang.instance()
		pointer.key = "ui_skill3"
		get_parent().add_child(pointer)
		pointer.position = position
		freeze = true
		boomerang_returned = false
		boomerang_enabled = false
	elif boomerang_returned:
		boomerang.queue_free()
		get_node("BoomerangTimer").start(BOOMERANG_WAIT_TIME)


func take_damage(damage):
	if not invincible:
		# play animation, to be added when the animation set is added
		health -= damage
		invincible = true
		get_node("InvincibilityTimer").start(INVINCIBILITY_WAIT_TIME)


func _physics_process(delta):
	# movement
	if not freeze:
		if not player_freeze:
			if not is_on_wall(): # move left and right if the player is not on wall
				velocity.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * HORIZONTAL_SPEED
				if Input.is_action_just_pressed("ui_jump") and is_on_floor(): # when the player presses jump
					velocity.y -= JUMP_STRENGTH - GRAVITY
				else:
					velocity.y += GRAVITY
			else:
				velocity.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * HORIZONTAL_SPEED
				velocity.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")) * VERTICAL_SPEED
		else:
			velocity.y += GRAVITY
		velocity = move_and_slide(velocity, Vector2.UP)
		
		# activate skills
		if Input.is_action_just_pressed("ui_skill1"):
			player_punch()
		if Input.is_action_just_pressed("ui_skill2"):
			player_kick()
		if Input.is_action_just_pressed("ui_skill3"):
			player_boomerang()


func _on_Hurtbox_area_exited(area):
	if area.name == 'Boomerang':
		if not boomerang_thrown:
			boomerang_thrown = true
		elif boomerang.velocity != Vector2.ZERO:
			take_damage(area.DAMAGE)
			boomerang.hit_player()


func _on_Hurtbox_area_entered(area):
	if area.name == 'Boomerang':
		boomerang_returned = true


func _on_PunchTimer_timeout():
	punch_enabled = true


func _on_KickTimer_timeout():
	kick_enabled = true


func _on_BoomerangTimer_timeout():
	boomerang_enabled = true


func _on_InvincibilityTimer_timeout():
	invincible = false
	# play a different animation, to be added when animation is ready
