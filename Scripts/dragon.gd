extends KinematicBody2D

# Dragon Animation Asset Source:
# https://danaida.itch.io/cartoon-dragon-sprite-pack/download/eyJpZCI6NzMxNzEwLCJleHBpcmVzIjoxNjYzODMyMDcyfQ%3d%3d%2eaqW11N%2fTcirE9ccJp16G2Q4OhNI%3d

const idle_pos_left = 2800
const idle_pos_right = 4700
const max_height = 1550

var velocity = Vector2.ZERO
var Fire = preload("res://Scenes/fire_by_dragon.tscn")
var fire
var is_attacking = false
var health = 100
var state_initiated = false
var rng = RandomNumberGenerator.new()
enum BOSS_STATE {IDLE, FLY, SPIT, DASH, KICK}
export (BOSS_STATE) var current_state = BOSS_STATE.IDLE



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	match current_state:
		BOSS_STATE.IDLE:
			if not state_initiated:
				state_initiated = true
				get_node("animation").animation = "idle"
				get_node("idle_timer").start()
				
			else:
				continue
			
		BOSS_STATE.FLY:
			continue
		
		BOSS_STATE.SPIT:
			continue
		
		BOSS_STATE.DASH:
			if not state_initiated:
				state_initiated = true
				get_node("animation").animation = "dash"
			else:
				continue
		
		BOSS_STATE.KICK:
			if not state_initiated:
				state_initiated = true
				get_node("animation").animation = "kick"
			continue
	

"""
	if dragon is far from the player, dash towards player
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
"""

func _on_firing_frequency_timeout():
	fire = Fire.instance()
	add_child(fire)

func fly_stomp_back():
	get_node("stomp_timer").wait_time = rng.randf_range(4, 7)
	get_node("stomp_timer").start()
	
	
	

func _on_idle_timer_timeout():
	if get_parent().get_node("player").position.y - position.y > 500:
		change_state(1)
	else:
		if abs(get_parent().get_node("player").position.x - position.x) < 100:
			change_state(2)
		else:
			change_state(3)

func _on_stomp_timer_timeout():
	pass # Replace with function body.
	
func change_state(mode):
	state_initiated = false
	if mode == 0:
		# back to idle
		current_state = BOSS_STATE.IDLE
	elif mode == 1:
		# player is on platform
		if rng.randi_range(1, 2) == 1:
			current_state = BOSS_STATE.FLY
		else:
			current_state = BOSS_STATE.SPIT
	elif mode == 2:
		# player is on ground and is near
		if rng.randi_range(1, 2) == 1:
			current_state = BOSS_STATE.KICK
		else:
			current_state = BOSS_STATE.FLY
	else:
		# player is on ground and is far
		var num = rng.randi_range(1, 3)
		if num == 1:
			current_state = BOSS_STATE.SPIT
		elif num == 2:
			current_state = BOSS_STATE.DASH
		else:
			current_state = BOSS_STATE.FLY

