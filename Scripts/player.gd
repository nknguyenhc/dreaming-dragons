extends KinematicBody2D


# appearance in the main map
const SCALE = 4
var animated_sprite

# movement
const GRAVITY = 50
var velocity = Vector2.ZERO
var temp_velocity
const JUMP_STRENGTH = 1200
const HORIZONTAL_SPEED = 450
const VERTICAL_SPEED = 300
var on_wall = false

# skills
var player_freeze = false # do not allow the player to move while activating some skills
var temp_state # state of player before executing kick
const Sword = preload("res://Scenes/Sword.tscn")
var sword
var sword_enabled = true
const SWORD_WAIT_TIME = 0.5
const Kick = preload("res://Scenes/kick.tscn")
var kick
var kick_enabled = true
const KICK_WAIT_TIME = 0.5
const Boomerang = preload("res://Scenes/pointer.tscn")
var pointer
var boomerang
var freeze = false # freeze the entire scene when activating boomerang
var boomerang_enabled = true
var boomerang_returned = false
var boomerang_thrown = false
var on_boomerang = false
var boomerang_key = "ui_skill3"
const BOOMERANG_WAIT_TIME = 0.5

# health
const MAX_HEALTH = 100
var health = MAX_HEALTH
var invincible = false
const INVINCIBILITY_WAIT_TIME = 1

# state of the player
enum PLAYER_STATE {IDLE, WALKING, SWORD, KICKING, CLIMBING, WALL_STATIONARY}
export (PLAYER_STATE) var current_state = PLAYER_STATE.IDLE
var idle_initiated = false
var walking_initiated = false
var kicking_initiated = false
var climbing_initiated = false
var wall_stationary_initiated = false

var is_boss_fight_started = false


# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(SCALE, SCALE)
	animated_sprite = get_node("AnimatedSprite")


func player_sword(right=true):
	if sword_enabled:
		player_freeze = true
		sword = Sword.instance()
		if is_on_floor():
			sword.swing_angle = PI
		else:
			sword.swing_angle = 3 * PI / 2
		sword.right = right
		add_child(sword)
		sword_enabled = false
		temp_state = current_state
		change_state(PLAYER_STATE.SWORD)

func end_sword():
	get_node("SwordTimer").start(SWORD_WAIT_TIME)
	player_freeze = false
	change_state(temp_state)


func player_kick(right):
	if kick_enabled:
		player_freeze = true
		kick = Kick.instance()
		if not right:
			kick.scale.x *= -1
		add_child(kick)
		kick_enabled = false
		get_node("KickTimer").start(KICK_WAIT_TIME)
		temp_state = current_state
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
	elif boomerang_returned and on_boomerang:
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
				animated_sprite.play("idle")
		
		PLAYER_STATE.WALKING:
			if not walking_initiated:
				walking_initiated = true
				animated_sprite.play("walking")
		
		PLAYER_STATE.SWORD:
			pass
		
		PLAYER_STATE.KICKING:
			if not kicking_initiated:
				kicking_initiated = true
				animated_sprite.play("kicking")
		
		PLAYER_STATE.CLIMBING:
			if not climbing_initiated:
				climbing_initiated = true
				animated_sprite.play("climbing")
		
		PLAYER_STATE.WALL_STATIONARY:
			if not wall_stationary_initiated:
				wall_stationary_initiated = true
				animated_sprite.play("climbing")
				animated_sprite.playing = false
	
	if not freeze:
		if not player_freeze:
			if not on_wall: # move left and right if the player is not on wall
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
				if velocity.y != 0:
					change_state(PLAYER_STATE.CLIMBING)
				else:
					change_state(PLAYER_STATE.WALL_STATIONARY)
		else:
			velocity.y += GRAVITY
			velocity.x = 0
		temp_velocity = move_and_slide(velocity, Vector2.UP)
		if temp_velocity.x != velocity.x:
			on_wall = true
		else:
			on_wall = false
		if velocity.x > 0:
			if animated_sprite.animation == "climbing":
				animated_sprite.flip_h = true
			else:
				animated_sprite.flip_h = false
		elif velocity.x < 0:
			if animated_sprite.animation == 'climbing':
				animated_sprite.flip_h = false
			else:
				animated_sprite.flip_h = true
		velocity = temp_velocity
		
		# activate skills
		if Input.is_action_just_pressed("ui_skill1"):
			player_sword(!animated_sprite.flip_h)
		if Input.is_action_just_pressed("ui_skill2"):
			player_kick(!animated_sprite.flip_h)
		if Input.is_action_just_pressed("ui_skill3"):
			player_boomerang()


func change_state(state):
	if current_state != state:
		idle_initiated = false
		walking_initiated = false
		kicking_initiated = false
		climbing_initiated = false
		wall_stationary_initiated = false
		if current_state == PLAYER_STATE.WALL_STATIONARY:
			animated_sprite.playing = true
		current_state = state


func _on_Hurtbox_area_exited(area):
	if area.name == 'Boomerang':
		on_boomerang = false
		if not boomerang_enabled:
			if not boomerang_thrown:
				boomerang_thrown = true
			elif boomerang.velocity != Vector2.ZERO:
				take_damage(area.DAMAGE)
				boomerang.hit_player()


func _on_Hurtbox_area_entered(area):
	if area.name == 'Boomerang':
		on_boomerang = true
		if boomerang_thrown: # first time boomerang area enter is when it appears in the scene
			boomerang_returned = true


func _on_KickTimer_timeout():
	kick_enabled = true


func _on_InvincibilityTimer_timeout():
	invincible = false
	# play a different animation, to be added when animation is ready


func _on_AnimatedSprite_animation_finished():
	if current_state == PLAYER_STATE.KICKING:
		get_node("Kick").queue_free()
		player_freeze = false # allow the player to move when the skill movement is done
		change_state(temp_state)


func _on_SwordTimer_timeout():
	sword_enabled = true
