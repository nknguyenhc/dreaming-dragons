extends KinematicBody2D


# Declare member variables here. Examples:
var gravity = 40
var velocity = Vector2(0, -700)
var health = 20
var prev_frame_health


# Called when the node enters the scene tree for the first time.
func _ready():
	prev_frame_health = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if prev_frame_health != health:
		get_parent().get_node("slime_bat_hurt").play()
	prev_frame_health = health
	velocity.y += gravity
	move_and_slide(velocity, Vector2.UP)	
	if is_on_floor():
		velocity = Vector2(0, -700)
	if health <= 0:
		queue_free()


func _on_Hurtbox_body_entered(body):
	if body.name == "Player":
		body.take_damage(3)

