extends KinematicBody2D


var Bullet = preload("res://Scenes/SlimeBullet.tscn")
var bullet

# Declare member variables here. Examples:
var gravity = 40
var velocity = Vector2(0, -700)
var health = 20
var prev_frame_health
var decrement = 1

var bullet_ready = true


# Called when the node enters the scene tree for the first time.
func _ready():
	prev_frame_health = health
	get_node("BulletTimer").wait_time = randi() % 5 + 5

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
		get_parent().slime_count -= decrement
		queue_free()
	if bullet_ready and (position - get_parent().get_node("Player").position).length() < 700:
		get_parent().get_node("slime_bat_attack").play()
		bullet = Bullet.instance()
		bullet.position = position
		get_parent().add_child(bullet)
		bullet_ready = false
		get_node("BulletTimer").start()

func _on_Hurtbox_body_entered(body):
	if body.name == "Player":
		body.take_damage(3)

func _on_BulletTimer_timeout():
	get_node("BulletTimer").wait_time = randi() % 5 + 5
	bullet_ready = true
