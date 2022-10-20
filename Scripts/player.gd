extends KinematicBody2D


# appearance in the main map
const SCALE = 4

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

# state of the player
enum PLAYER_STATE {IDLE, WALKING, PUNCHING, KICKING, CLIMBING}
export (PLAYER_STATE) var current_state = PLAYER_STATE.IDLE
var idle_initiated = false
var walking_initiated = false
var punching_initiated = false
var kicking_initiated = false
var climbing_initiated = false


# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(SCALE, SCALE)


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
		change_state(PLAYER_STATE.PUNCHING)


func player_kick():
	if kick_enabled:
		player_freeze = true
		kick = Kick.instance()
		add_child(kick)
		kick_enabled = false
		get_node("KickTimer").start(KICK_WAIT_TIME)
		change_state(PLAYER_STATE.KICKING)


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
		boomerang_enabled = true
		boomerang_returned = false
		boomerang_thrown = false
		boomerang.queue_free()


func take_damage(damage):
	if not invincible:
		# play animation, to be added when the animation set is added
		health -= damage
		print(health)
		invincible = true
		get_node("InvincibilityTimer").start(INVINCIBILITY_WAIT_TIME)


func _physics_process(delta):
	# movement
	match current_state:
		PLAYER_STATE.IDLE:
			if not idle_initiated:
				idle_initiated = true
				get_node("AnimatedSprite").animation = "idle"
		
		PLAYER_STATE.WALKING:
			if not walking_initiated:
				walking_initiated = true
				get_node("AnimatedSprite").animation = "walking"
		
		PLAYER_STATE.PUNCHING:
			if not punching_initiated:
				punching_initiated = true
				get_node("AnimatedSprite").animation = "punching"
		
		PLAYER_STATE.KICKING:
			if not kicking_initiated:
				kicking_initiated = true
				get_node("AnimatedSprite").animation = "kicking"
		
		PLAYER_STATE.CLIMBING:
			continue
	
	if not freeze:
		if not player_freeze:
			if not is_on_wall(): # move left and right if the player is not on wall
				if velocity.x == 0 or velocity.y != 0:
					change_state(PLAYER_STATE.IDLE)
				else:
					change_state(PLAYER_STATE.WALKING)
				velocity.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * HORIZONTAL_SPEED
				if Input.is_action_just_pressed("ui_jump") and is_on_floor(): # when the player presses jump
					velocity.y -= JUMP_STRENGTH - GRAVITY
				else:
					velocity.y += GRAVITY
				# animation
			else:
				velocity.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * HORIZONTAL_SPEED
				velocity.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")) * VERTICAL_SPEED
				change_state(PLAYER_STATE.CLIMBING)
		else:
			velocity.y += GRAVITY
		velocity = move_and_slide(velocity, Vector2.UP)
		if velocity.x > 0:
			get_node("AnimatedSprite").flip_h = false
		elif velocity.x < 0:
			get_node("AnimatedSprite").flip_h = true
		
		# activate skills
		if Input.is_action_just_pressed("ui_skill1"):
			player_punch()
		if Input.is_action_just_pressed("ui_skill2"):
			player_kick()
		if Input.is_action_just_pressed("ui_skill3"):
			player_boomerang()


func change_state(state):
	if current_state != state:
		idle_initiated = false
		walking_initiated = false
		punching_initiated = false
		kicking_initiated = false
		climbing_initiated = false
		current_state = state


func _on_Hurtbox_area_exited(area):
	if area.name == 'Boomerang':
		if not boomerang_enabled:
			if not boomerang_thrown:
				boomerang_thrown = true
			elif boomerang.velocity != Vector2.ZERO:
				take_damage(area.DAMAGE)
				boomerang.hit_player()


func _on_Hurtbox_area_entered(area):
	if area.name == 'Boomerang':
		if boomerang_thrown: # first time boomerang area enter is when it appears in the scene
			boomerang_returned = true


func _on_PunchTimer_timeout():
	punch_enabled = true


func _on_KickTimer_timeout():
	kick_enabled = true


func _on_InvincibilityTimer_timeout():
	invincible = false
	# play a different animation, to be added when animation is ready
