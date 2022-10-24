extends KinematicBody2D

var Bullet = preload("res://Scenes/BatBullet.tscn")
var bullet

var speed = 3
var flag = true
var timeout = false
var health = 15
var is_damaging = false
var bullet_ready = true

func _ready():
	get_node("BulletTimer").wait_time = randi() % 3 + 3 + floor(randf())

func _physics_process(delta):
	if health <= 0:
		queue_free()
	if is_damaging:
		get_parent().get_node("Player").take_damage(10);
	
	if get_parent().slime_count <= 0:
		if flag == true:
			get_node("Timer").start()
			flag = false
		elif timeout == true:
			position.x = move_toward(position.x, get_parent().get_node("Player").position.x, speed)
			position.y = move_toward(position.y, get_parent().get_node("Player").position.y, speed)
	
		if bullet_ready and (position - get_parent().get_node("Player").position).length() < 800:
			bullet = Bullet.instance()
			bullet.position = position
			get_parent().add_child(bullet)
			bullet_ready = false
			get_node("BulletTimer").start()


func _on_Hurtbox_body_entered(body):
	if body.name == "Player":
		is_damaging = true
		
func _on_Hurtbox_body_exited(body):
	if body.name == "Player":
		is_damaging = false


func _on_Timer_timeout():
	timeout = true

func _on_BulletTimer_timeout():
	get_node("BulletTimer").wait_time = randi() % 3 + 3 + floor(randf())
	bullet_ready = true
