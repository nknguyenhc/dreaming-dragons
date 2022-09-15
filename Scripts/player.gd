extends KinematicBody2D


# movement
var velocity = Vector2.ZERO
const JUMP_STRENGTH = 100
var direction

# skills
const Punch = preload("res://Scenes/punch.tscn")
var punch
const Kick = preload("res://Scenes/kick.tscn")
var kick
const Boomerang = preload("res://Scenes/boomerang.tscn")
var boomerang

# health
const MAX_HEALTH = 100
var health = MAX_HEALTH
const BOOMERANG_DAMAGE = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func player_punch():
	punch = Punch.instance()
	add_child(punch)


func player_kick():
	kick = Kick.instance()
	add_child(kick)


func player_boomerang():
	boomerang = Boomerang.instance()
	boomerang.direction = direction
	get_parent().add_child(boomerang)


func _physics_process(delta):
	# movement
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction = Vector2(velocity.x, 0)
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


func _on_Hurtbox_area_entered(area):
	if area.name == 'Boomerang':
		health -= BOOMERANG_DAMAGE
		area.disappear()
