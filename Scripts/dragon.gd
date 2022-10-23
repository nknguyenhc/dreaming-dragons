extends KinematicBody2D

# Dragon Animation Asset Source:
# https://danaida.itch.io/cartoon-dragon-sprite-pack/download/eyJpZCI6NzMxNzEwLCJleHBpcmVzIjoxNjYzODMyMDcyfQ%3d%3d%2eaqW11N%2fTcirE9ccJp16G2Q4OhNI%3d
var player

const idle_pos_left = 2780
const idle_pos_right = 4730
const max_height = -1550
const ceiling_height = -1700
const HB = preload("res://Scenes/Dragon Health.tscn")
var hb = HB.instance()

var is_boss_fight_started = false
var is_player_close = false
var velocity = Vector2.ZERO

# skills
var fire
var health = 100
var damage = 10
var state_initiated = false
var to_stomp = false
var stomp_initiated = false
var rng = RandomNumberGenerator.new()
var delay_timeout = false
var is_back = false
var is_fly_back = false
var fly_back_dest = idle_pos_left
var is_dash_back = false
var direction = -1 # -1 is left and 1 is right
var dash_dest = idle_pos_left
const FireBall = preload("res://Scenes/fire_by_dragon.tscn")
var first_fire_ball
var fire_initialised = false
const MAX_N_FIRE_BALLS = 69
var current_n_fire_balls = 0

enum BOSS_STATE {IDLE, FLY, SPIT, DASH, KICK, FLYBACK}
export (BOSS_STATE) var current_state = BOSS_STATE.IDLE


func _ready():
	player = get_parent().get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if !is_player_close:
		if player.position.y < -750 && !is_boss_fight_started:
			is_boss_fight_started = true
			get_node("delay_timer").wait_time = 2
			get_node("delay_timer").start()
		if delay_timeout:
			is_player_close = true
			delay_timeout = false
			get_parent().get_node("Map1").get_node("Camera2D").add_child(hb)
			
	
	else:
		hb.get_node("dragonhealthbar").value = health
		match current_state:
			
			BOSS_STATE.IDLE: # done
				if not state_initiated:			
					state_initiated = true
					
					if abs(position.x - idle_pos_left) < abs(position.x - idle_pos_right): # should face right
						direction = 1
						check_and_change_direction()
					else:
						direction = -1
						check_and_change_direction()
					get_node("animation").animation = "idle"
					get_node("idle_timer").start()
				
			BOSS_STATE.FLY: # done
				if not state_initiated:
					state_initiated = true
					is_back = false
					get_node("animation").animation = "fly"
					to_stomp = false
					stomp_initiated = false
					get_node("stomp_timer").wait_time = rng.randi_range(5, 7)
					get_node("stomp_timer").start()
				
				if !stomp_initiated && abs(player.position.x - position.x) < 50 \
									 && player.position.y > position.y:
					to_stomp = true
				
				if !stomp_initiated && to_stomp:
					get_node("delay_timer").wait_time = 0.2
					get_node("delay_timer").start()
					to_stomp = false
					stomp_initiated = true
				
				if stomp_initiated && delay_timeout:
					velocity = Vector2(0, 1500)
					move_and_slide(velocity, Vector2.UP)
					if is_on_floor():
						is_back = true
						delay_timeout = false
						
				elif !is_back: # initial fly up and horizontally
					velocity = Vector2(0, -400)
					if position.y < max_height:
						velocity = Vector2(400 * direction, 0)
					move_and_slide(velocity)
				
				if is_back:
					if position.y < -1000: # on platform
						change_state(4)
					else: # on ground
						change_state(5)
					is_back = false
			
			BOSS_STATE.FLYBACK: # done
				if not state_initiated:
					if direction == 1:
						fly_back_dest = idle_pos_right
					else:
						fly_back_dest = idle_pos_left
					state_initiated = true
				
				velocity = Vector2(0, -400)
				if position.y < max_height:
					velocity = Vector2(400 * direction, 0)
				if abs(position.x - fly_back_dest) < 20:
					velocity = Vector2(0, 400)
				move_and_slide(velocity, Vector2.UP)
				if is_on_floor():
					change_state(0)
				
				
			BOSS_STATE.SPIT:
				if not state_initiated:
					print("spitting fire")
					first_fire_ball = FireBall.instance()
					var another_fire_ball = FireBall.instance()
					first_fire_ball.landed = false
					first_fire_ball.position = Vector2(player.position.x, ceiling_height)
					first_fire_ball.dragon = self
					first_fire_ball.player = player
					first_fire_ball.direction_of_spread = "both"
					get_parent().add_child(first_fire_ball)
					state_initiated = true
				if current_n_fire_balls >= MAX_N_FIRE_BALLS:
					current_n_fire_balls = 0
					first_fire_ball.queue_free()
					change_state(3)
			
			BOSS_STATE.DASH: # done
				if not state_initiated:
					state_initiated = true
					var dif = player.position.x - position.x
					if dif > 0:
						direction = 1
						dash_dest = idle_pos_right
					else:
						direction = -1
						dash_dest = idle_pos_left
					check_and_change_direction()
					velocity =  Vector2(dif, 0).normalized() * 800
					get_node("animation").animation = "dash"
				
				move_and_slide(velocity)
				if abs(position.x - dash_dest) < 20:
					direction *= -1
					check_and_change_direction()
					change_state(0)
					
							
			BOSS_STATE.KICK: # done
				if not state_initiated:
					state_initiated = true
					damage = 20
					get_node("animation").animation = "kick"
					position.x += 50 * direction
					get_node("delay_timer").wait_time = 0.6
					get_node("delay_timer").start()
				
				if delay_timeout:
					damage = 10
					position.x -= 50 * direction
					delay_timeout = false
					change_state(0)
				

func check_and_change_direction():
	if direction == 1: # right
		get_node("animation").flip_h = false
	else:
		get_node("animation").flip_h = true


func _on_idle_timer_timeout():
	if player.position.y - position.y > 500:
		change_state(1)
	else:
		if abs(player.position.x - position.x) < 100:
			change_state(2)
		else:
			change_state(3)
	get_node("idle_timer").stop()

func _on_stomp_timer_timeout():
	if !stomp_initiated:
		to_stomp = true
	get_node("stomp_timer").stop()
	
func _on_delay_timer_timeout():
	delay_timeout = true
	get_node("delay_timer").stop()
	
func change_state(mode):
	velocity = Vector2.ZERO
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
		if rng.randi_range(1, 2) == 1 && player.position.y > -850:
			current_state = BOSS_STATE.KICK
		else:
			current_state = BOSS_STATE.FLY
	elif mode == 3:
		# player is on ground and is far
		var num = rng.randi_range(1, 3)
		if num == 1:
			current_state = BOSS_STATE.SPIT
		elif num == 2:
			current_state = BOSS_STATE.DASH
		else:
			current_state = BOSS_STATE.FLY
	elif mode == 4:
		current_state = BOSS_STATE.FLYBACK
	else:
		# mode 5 dash back
		current_state = BOSS_STATE.DASH
		
