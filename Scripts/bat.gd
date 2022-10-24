extends KinematicBody2D

# Bat asset source: https://jumelord.itch.io/bat

var Bullet = preload("res://Scenes/BatBullet.tscn")
var bullet

#var velocity = Vector2.ZERO
var t = 0
var rng = RandomNumberGenerator.new()
var add_on = 0
var health = 15
var is_damaging = false
var bullet_ready = true

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("BulletTimer").wait_time = randi() % 3 + 3 + floor(randf())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	t += delta
	position.x += 5 * sin(3 * t + add_on)
	position.y += 1 * cos(3 * t + add_on)
	if health <= 0:
		queue_free()
	if is_damaging:
		get_parent().get_node("Player").take_damage(10)
	
	if get_parent().slime_count <= 0:
		if bullet_ready and (position - get_parent().get_node("Player").position).length() < 800:
			bullet = Bullet.instance()
			bullet.position = position
			get_parent().add_child(bullet)
			bullet_ready = false
			get_node("BulletTimer").start()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		is_damaging = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		is_damaging = false

func _on_BulletTimer_timeout():
	get_node("BulletTimer").wait_time = randi() % 3 + 3 + floor(randf())
	bullet_ready = true
