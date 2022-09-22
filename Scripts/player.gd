extends KinematicBody2D


# movement
var velocity = Vector2.ZERO
const JUMP_STRENGTH = 100
const HORIZONTAL_SPEED = 20
var direction = Vector2.RIGHT

# skills
var freeze = false # do not allow the player to move while activating some skills
const Punch = preload("res://Scenes/punch.tscn")
var punch
var punch_enabled = true
const PUNCH_WAIT_TIME = 1
const Kick = preload("res://Scenes/kick.tscn")
var kick
var kick_enabled = true
const KICK_WAIT_TIME = 1
const Boomerang = preload("res://Scenes/boomerang.tscn")
var boomerang
var boomerang_enabled = true
var boomerang_returned = false
const BOOMERANG_WAIT_TIME = 0.5

# health
const MAX_HEALTH = 100
var health = MAX_HEALTH


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func player_punch():
	if punch_enabled:
		freeze = true
		punch = Punch.instance()
		add_child(punch)
		punch_enabled = false
		get_node("PunchTimer").start(PUNCH_WAIT_TIME)


func player_kick():
	if kick_enabled:
		freeze = true
		kick = Kick.instance()
		add_child(kick)
		kick_enabled = false
		get_node("KickTimer").start(KICK_WAIT_TIME)


func player_boomerang():
	if not get_parent().has_node("Boomerang"):
		if boomerang_enabled:
			boomerang = Boomerang.instance()
			boomerang.direction = direction
			get_parent().add_child(boomerang)
			boomerang_returned = false
	else:
		if boomerang_returned:
			boomerang.queue_free()
			boomerang_enabled = false
			get_node("BoomerangTimer").start(BOOMERANG_WAIT_TIME)


func _physics_process(delta):
	# movement
	if not freeze:
		velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		if velocity.x != 0: # change direction only when the player moves, not when static
			direction = Vector2(velocity.x, 0)
		velocity.x *= HORIZONTAL_SPEED
		if Input.is_action_just_pressed("ui_jump") and is_on_floor():
			velocity.y = -JUMP_STRENGTH
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
		health -= boomerang.DAMAGE
		player_boomerang()


func _on_Hurtbox_area_entered(area):
	boomerang_returned = true


func _on_PunchTimer_timeout():
	punch_enabled = true


func _on_KickTimer_timeout():
	kick_enabled = true


func _on_BoomerangTimer_timeout():
	boomerang_enabled = true
