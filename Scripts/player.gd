extends KinematicBody2D


# appearance in the main map
const SCALE = 4
var animated_sprite

# movement
const GRAVITY = 50
var velocity = Vector2.ZERO
var temp_velocity
const JUMP_STRENGTH = 1100
const HORIZONTAL_SPEED = 400
const VERTICAL_SPEED = 300
# jump
var can_jump = false # raycast detection
var last_frame_on_floor = false
const OFF_PLATFORM_GRACE_PERIOD = 0.2
var off_platform_timer
# climb wall
var on_wall = false
var can_climb = true
const TEMP_SPEED_LIMIT = 20 # to detect whether the player is on wall
var wall_v_speed = 0

#SFX
var is_climb_music_playing = false
var is_walk_music_playing = false

# collectibles
var boomerang_collected = false
var sword_collected = false
var SwordTutorial = preload("res://Scenes/SwordTutorial.tscn")
var sword_tutorial
var BoomerangTutorial = preload("res://Scenes/BoomerangTutorial.tscn")
var boomerang_tutorial

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
var kick_animation_playing = false
const KICK_WAIT_TIME = 0.5
const Boomerang = preload("res://Scenes/pointer.tscn")
var pointer
var boomerang
var boomerang_enabled = true
var boomerang_returned = false
var boomerang_thrown = false
var on_boomerang = false
var boomerang_key = "ui_skill3"
const BOOMERANG_WAIT_TIME = 0.5

# health
const MAX_HEALTH = 200
var health = MAX_HEALTH
var invincible = false
const INVINCIBILITY_WAIT_TIME = 1.8
const RECOIL_SPEED = 250
const RECOIL_TIME = 0.2
var recoiling = false

# state of the player
enum PLAYER_STATE {IDLE, WALKING, SWORD, KICKING, CLIMBING, WALL_STATIONARY, TAKE_DAMAGE}
export (PLAYER_STATE) var current_state = PLAYER_STATE.IDLE
var idle_initiated = false
var walking_initiated = false
var kicking_initiated = false
var climbing_initiated = false
var wall_stationary_initiated = false
var take_damage_initiated = false

var is_boss_fight_started = false
var Health_bars = preload("res://Scenes/Player Health.tscn")
var health_bar = Health_bars.instance()


# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(SCALE, SCALE)
	animated_sprite = get_node("AnimatedSprite")
	get_parent().get_node("Map1").get_node("Camera2D").add_child(health_bar)
	off_platform_timer = get_node("OffPlatformTimer")


func player_sword(right=true):
	if sword_enabled:
		player_freeze = true
		get_node("sword_swing").play()
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
		kick_animation_playing = true
		get_node("player_kick").play()
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
		get_parent().get_tree().paused = true
		boomerang_returned = false
		boomerang_enabled = false
	elif boomerang_returned and on_boomerang:
		get_node("boomerang_catch").play()
		boomerang_enabled = true
		boomerang_returned = false
		boomerang_thrown = false
		boomerang.queue_free()


func take_damage(damage):
	if not invincible:
		get_node("player_hurt").play()
		if current_state == PLAYER_STATE.KICKING:
			get_node("Kick").queue_free()
			player_freeze = false
		if current_state == PLAYER_STATE.SWORD:
			get_node("Sword").queue_free()
			get_node("SwordTimer").start(SWORD_WAIT_TIME)
			player_freeze = false
		change_state(PLAYER_STATE.TAKE_DAMAGE)
		health -= damage
		invincible = true
		get_node("InvincibilityTimer").start(INVINCIBILITY_WAIT_TIME)

func die():
	set_physics_process(false)
	get_node("AnimatedSprite").play("vanishing")
	get_node("AnimatedSprite").scale = Vector2(0.8,0.8)
	get_node("VanishTimer").start()
	get_node("AnimatedSprite").speed_scale = 0.4
	

func _physics_process(delta):		
	
	if health <= 0:
		die()
	
	match current_state:
		PLAYER_STATE.IDLE:
			if not idle_initiated:
				idle_initiated = true
				animated_sprite.play("idle")
		
		PLAYER_STATE.WALKING:
			if not walking_initiated:
				walking_initiated = true
				animated_sprite.play("walking")
				get_node("walk").play()
		
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
		
		PLAYER_STATE.TAKE_DAMAGE:
			if not take_damage_initiated:
				take_damage_initiated = true
				if health > 0:
					animated_sprite.play("take_damage")
				velocity = Vector2.ZERO
				# recoil fall down
				get_node("RecoilTimer").start(RECOIL_TIME)
				recoiling = true
			else:
				# recoil
				if recoiling:
					if animated_sprite.flip_h:
						velocity.x = RECOIL_SPEED
					else:
						velocity.x = -RECOIL_SPEED
					velocity.y += GRAVITY
				else:
					velocity.x = 0
					velocity.y += GRAVITY
	
	if not player_freeze and current_state != PLAYER_STATE.TAKE_DAMAGE:
		if not on_wall: # move left and right if the player is not on wall
			if velocity.x == 0 or velocity.y != 0:
				change_state(PLAYER_STATE.IDLE)
			else:
				change_state(PLAYER_STATE.WALKING)
			velocity.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * HORIZONTAL_SPEED
			if Input.is_action_just_pressed("ui_jump") and (is_on_floor() or can_jump): # when the player presses jump
				get_node("jump").play()
				velocity.y -= JUMP_STRENGTH - GRAVITY
				last_frame_on_floor = false # to avoid activating the off_platform_timer
				if not off_platform_timer.is_stopped():
					off_platform_timer.stop()
					can_jump = false
			else:
				velocity.y += GRAVITY
				if is_on_floor():
					last_frame_on_floor = true
					if not off_platform_timer.is_stopped():
						off_platform_timer.stop()
						can_jump = false
				elif last_frame_on_floor:
					can_jump = true
					off_platform_timer.start(OFF_PLATFORM_GRACE_PERIOD)
					last_frame_on_floor = false
		elif can_climb:
			velocity.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * HORIZONTAL_SPEED
			velocity.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")) * VERTICAL_SPEED
			if velocity.y != 0:
				change_state(PLAYER_STATE.CLIMBING)
				if not is_climb_music_playing:
					get_node("climb").play()
					is_climb_music_playing = true
			else:
				change_state(PLAYER_STATE.WALL_STATIONARY)
				is_climb_music_playing = false
			velocity.y += wall_v_speed # in case of climbing on a moving platform, wall_v_speed is non-zero
	elif current_state != PLAYER_STATE.TAKE_DAMAGE: # player being frozen due to sword
		velocity.y += GRAVITY
		if is_on_floor() or !current_state == PLAYER_STATE.KICKING:
			velocity.x = 0
	temp_velocity = move_and_slide(velocity, Vector2.UP)
	if abs(temp_velocity.x) < TEMP_SPEED_LIMIT and velocity.x != 0:
		on_wall = true
		if get_slide_count() > 0:
			var collider = get_slide_collision(0).collider
			if "mp" in collider.name and collider.is_vertical: # climbing on vertically moving platform
				wall_v_speed = collider.speed * collider.dir
	else:
		on_wall = false
		wall_v_speed = 0 # must reset this variable whenever the player leaves a wall
	if velocity.x > 0 and current_state != PLAYER_STATE.TAKE_DAMAGE:
		if animated_sprite.animation == "climbing":
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	elif velocity.x < 0 and current_state != PLAYER_STATE.TAKE_DAMAGE:
		if animated_sprite.animation == 'climbing':
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	velocity = temp_velocity
	
	if current_state != PLAYER_STATE.TAKE_DAMAGE:
		# activate skills
		if Input.is_action_just_pressed("ui_skill1") and current_state != PLAYER_STATE.KICKING and sword_collected:
			player_sword(!animated_sprite.flip_h)
		if Input.is_action_just_pressed("ui_skill2") and current_state != PLAYER_STATE.SWORD:
			player_kick(!animated_sprite.flip_h)
		if Input.is_action_just_pressed("ui_skill3") and boomerang_collected:
			player_boomerang()
	
	# health bar
	health_bar.get_node("Player Health Bar").value = health * 100 / MAX_HEALTH 


func change_state(state):
	if current_state == PLAYER_STATE.CLIMBING && state != PLAYER_STATE.CLIMBING:
		get_node("climb").stop()
	if current_state == PLAYER_STATE.WALKING && state != PLAYER_STATE.WALKING:
		get_node("walk").stop()
	if current_state != state:
		idle_initiated = false
		walking_initiated = false
		kicking_initiated = false
		climbing_initiated = false
		wall_stationary_initiated = false
		take_damage_initiated = false
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
	
	if area.name == "BoomerangCollectible":
		boomerang_collected = true
		get_node("collectible").play()
		area.queue_free()
		boomerang_tutorial = BoomerangTutorial.instance()
		get_parent().camera.add_child(boomerang_tutorial)
		get_parent().get_tree().paused = true
	
	if area.name == "SwordCollectible":
		sword_collected = true
		get_node("collectible").play()
		area.queue_free()
		sword_tutorial = SwordTutorial.instance()
		get_parent().camera.add_child(sword_tutorial)
		get_parent().get_tree().paused = true


func _on_KickTimer_timeout():
	kick_enabled = true


func _on_InvincibilityTimer_timeout():
	invincible = false


func _on_AnimatedSprite_animation_finished():
	if current_state == PLAYER_STATE.KICKING:
		get_node("Kick").queue_free()
		player_freeze = false # allow the player to move when the skill movement is done
		change_state(temp_state)
	if current_state == PLAYER_STATE.TAKE_DAMAGE:
		change_state(PLAYER_STATE.IDLE)


func _on_SwordTimer_timeout():
	sword_enabled = true


func _on_VanishTimer_timeout():
	get_parent().get_parent().restart()


func _on_KickAnimationTimer_timeout():
	kick_animation_playing = false
	

func _on_RecoilTimer_timeout():
	recoiling = false


func _on_OffPlatformTimer_timeout():
	can_jump = false
