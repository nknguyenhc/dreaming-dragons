extends KinematicBody2D

# Dragon Animation Asset Source:
# https://danaida.itch.io/cartoon-dragon-sprite-pack/download/eyJpZCI6NzMxNzEwLCJleHBpcmVzIjoxNjYzODMyMDcyfQ%3d%3d%2eaqW11N%2fTcirE9ccJp16G2Q4OhNI%3d


var velocity = Vector2.ZERO
var status
var Fire = preload("res://Scenes/fire_by_dragon.tscn")
var fire
var is_attacking = false
var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("animation").animation = "idle"
	status = "idle"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
# if dragon is far from the player, dash towards player
	if (position.x - get_parent().get_node("player").position.x) < 1000 and status != "dashing":
		status = "dashing"
		get_node("animation").animation = "dash"
		velocity = Vector2(-200,0)
		if get_node("firing_frequency").time_left > 0:
			get_node("firing_frequency").stop()

	# if player is close to the dragon, dragon attacks player by fire
	elif (position.x - get_parent().get_node("player").position.x) < 800 and status != "attacking":
		get_node("firing_frequency").start()
		velocity = Vector2.ZERO
		status = "attacking"
		get_node("animation").animation = "attack"
	
	elif status != "idle":
		get_node("animation").animation = "idle"
		status = "idle"


func _on_firing_frequency_timeout():
	fire = Fire.instance()
	add_child(fire)
