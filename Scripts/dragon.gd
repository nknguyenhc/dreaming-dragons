extends KinematicBody2D

# Dragon Animation Asset Source:
# https://danaida.itch.io/cartoon-dragon-sprite-pack/download/eyJpZCI6NzMxNzEwLCJleHBpcmVzIjoxNjYzODMyMDcyfQ%3d%3d%2eaqW11N%2fTcirE9ccJp16G2Q4OhNI%3d
var player

const idle_pos_left = 2780
const idle_pos_right = 4730
const max_height = -1680
const ceiling_height = -1700
const HB = preload("res://Scenes/Dragon Health.tscn")
var hb = HB.instance()

var is_boss_fight_started = false
var is_player_close = false
var velocity = Vector2.ZERO

# skills
var FLY_SPEED = 400
const STOMP_MARKER = 1000
const STOMP_SPEED = 1500
var IDLE_TIME = 2.5
var STOMP_DELAY_TIME = 0.15
var fire
var health = 100
var LEVEL2_MARK = 50
var is_level_2_music_played = false
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
const MAX_N_FIRE_BALLS = 109
var current_n_fire_balls = 0
var spit_fire_from_drag = false
const SPIT_FIRE_WHILE_FLYING_CHANCES = 100
const SPIT_FIRE_HEIGHT = -1300
const GROUND_MARKER = -950

# healing items
const medicine_pos_1 = Vector2(3008, -1201)
const medicine_pos_2 = Vector2(3506, -1356)
const medicine_pos_3 = Vector2(3973, -1213)
const medicine_pos_4 = Vector2(4482, -1365)
const Medicine = preload("res://Scenes/medicine.tscn")
var medicine
var medicine_num
var is_medicine_exist = false

var Ending_Animation = preload("res://Scenes/Ending.tscn")
var ending_animation
var is_death_initiated = false

enum BOSS_STATE {IDLE, FLY, SPIT, SPIT_ON_AIR, DASH, KICK, FLYBACK}
export (BOSS_STATE) var current_state = BOSS_STATE.IDLE


func _ready():
	player = get_parent().get_node("Player")
	if get_parent().get_parent().cur_mode == "Medium":
		LEVEL2_MARK = 50
	elif get_parent().get_parent().cur_mode == "Hard":
		LEVEL2_MARK = 65
	else:
		LEVEL2_MARK = 80


func _physics_process(delta):
	hb.get_node("dragonhealthbar").value = health
	if health <= 0:
		if not is_death_initiated:
			get_node("dragon_idle").play()
			get_node("animation").animation = "death"
			get_node("death_timer").start()
			is_death_initiated = true
			velocity = Vector2(0, 0)
		velocity.y += 10
		move_and_slide(velocity)
	else:
	
		if !is_player_close:
			if player.position.y < -750 && player.position.x > 2000 && !is_boss_fight_started:
				is_boss_fight_started = true
				get_node("delay_timer").wait_time = 2
				get_node("delay_timer").start()
			if delay_timeout:
				is_player_close = true
				delay_timeout = false
				get_parent().get_node("Map1").get_node("Camera2D").add_child(hb)
				
		
		else:			
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
						get_node("dragon_idle").play()
						get_node("animation").animation = "idle"
						get_node("idle_timer").wait_time = IDLE_TIME
						get_node("idle_timer").start()
						medicine_num = rng.randi_range(1,2)
						print(medicine_num)
						if medicine_num == 1 && not is_medicine_exist:
							is_medicine_exist = true
							medicine = Medicine.instance()
							medicine_num = rng.randi_range(1,4)
							if medicine_num == 1:
								medicine.position = medicine_pos_1
							elif medicine_num == 2:
								medicine.position = medicine_pos_2
							elif medicine_num == 3:
								medicine.position = medicine_pos_3
							else:
								medicine.position = medicine_pos_4
							get_parent().get_node("Map1").add_child(medicine)
					
				BOSS_STATE.FLY: # done
					if not state_initiated:
						if direction == 1:
							fly_back_dest = idle_pos_right
						else:
							fly_back_dest = idle_pos_left
						state_initiated = true
						is_back = false
						get_node("animation").animation = "fly"
						to_stomp = false
						stomp_initiated = false
						get_node("stomp_timer").wait_time = rng.randi_range(5, 7)
						get_node("stomp_timer").start()
					
					if spit_fire_from_drag and !stomp_initiated and !to_stomp and position.y < SPIT_FIRE_HEIGHT\
						and player.is_on_floor() and player.position.y > GROUND_MARKER:
						if rng.randi_range(1, SPIT_FIRE_WHILE_FLYING_CHANCES) == 1:
							change_state(7)
					
					if (!stomp_initiated and abs(player.position.x - position.x) < 50 \
							and player.position.y > position.y) or abs(position.x - fly_back_dest) < 50:
						to_stomp = true
					
					if !stomp_initiated && to_stomp:
						get_node("delay_timer").wait_time = STOMP_DELAY_TIME
						get_node("delay_timer").start()
						to_stomp = false
						stomp_initiated = true
					
					if stomp_initiated && delay_timeout:
						velocity = Vector2(0, STOMP_SPEED)
						move_and_slide(velocity, Vector2.UP)
						if is_on_floor():
							get_node("dragon_stomp").play()
							is_back = true
							delay_timeout = false
							
					elif !is_back: # initial fly up and horizontally
						velocity = Vector2(0, -FLY_SPEED)
						if position.y < max_height:
							velocity = Vector2(FLY_SPEED * direction, 0)
						move_and_slide(velocity)
					
					if is_back:
						if position.y < -STOMP_MARKER: # on platform
							change_state(4)
						else: # on ground
							change_state(6)
						is_back = false
				
				BOSS_STATE.FLYBACK: # done
					if not state_initiated:
						if direction == 1:
							fly_back_dest = idle_pos_right
						else:
							fly_back_dest = idle_pos_left
						state_initiated = true
					
					velocity = Vector2(0, -FLY_SPEED)
					if position.y < max_height:
						velocity = Vector2(FLY_SPEED * direction, 0)
					if abs(position.x - fly_back_dest) < 20:
						velocity = Vector2(0, FLY_SPEED)
					move_and_slide(velocity, Vector2.UP)
					if is_on_floor():
						change_state(0)
					
					
				BOSS_STATE.SPIT:
					if not state_initiated:
						get_node("dragon_spit").play()
						get_node("animation").animation = "attack"
						fire_from_pos(player.position.x, ceiling_height)
						state_initiated = true
					if current_n_fire_balls >= MAX_N_FIRE_BALLS:
						current_n_fire_balls = 0
						first_fire_ball.queue_free()
						fire_initialised = false
						change_state(3)
				
				BOSS_STATE.SPIT_ON_AIR:
					if not state_initiated:
						get_node("dragon_spit").play()
						get_node("animation").animation = "attack"
						fire_from_pos(position.x, position.y)
						state_initiated = true
					if current_n_fire_balls >= MAX_N_FIRE_BALLS:
						current_n_fire_balls = 0
						first_fire_ball.queue_free()
						fire_initialised = false
						change_state(5)
				
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
						get_node("dragon_dash").play()
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
						get_node("dragon_kick").play()
						get_node("animation").animation = "kick"
						position.x += 50 * direction
						get_node("delay_timer").wait_time = 0.6
						get_node("delay_timer").start()
					
					if delay_timeout:
						position.x -= 50 * direction
						delay_timeout = false
						change_state(0)
		
		if health < LEVEL2_MARK:
			if not is_level_2_music_played:
				is_level_2_music_played = true
				get_node("dragon_spit").play()
			FLY_SPEED = 600
			spit_fire_from_drag = true
			IDLE_TIME = 1
			STOMP_DELAY_TIME = 0.05
			get_node("animation").modulate = Color(1, 0.3, 0.3)


func fire_from_pos(x, y):
	first_fire_ball = FireBall.instance()
	first_fire_ball.landed = false
	first_fire_ball.position = Vector2(x, y)
	first_fire_ball.dragon = self
	first_fire_ball.player = player
	first_fire_ball.direction_of_spread = "both"
	get_parent().add_child(first_fire_ball)
	fire_initialised = true


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
	
func _on_death_timer_timeout():
	ending_animation = Ending_Animation.instance()
	get_parent().get_node("Map1").get_node("Camera2D").add_child(ending_animation)
	for child in get_children():
		child.queue_free()
	for child in get_parent().get_children():
		if child.name == "fire_by_dragon":
			child.queue_free()
	get_parent().get_node("boss_bgm").stop()
	get_parent().get_node("victory_bgm").play()
	
func change_state(mode):
	velocity = Vector2.ZERO
	state_initiated = false
	if mode == 0:
		# back to idle
		current_state = BOSS_STATE.IDLE
	elif mode == 1:
		# player is on platform
		if rng.randi_range(1, 2) == 1 and not fire_initialised:
			current_state = BOSS_STATE.SPIT
		else:
			current_state = BOSS_STATE.FLY
	elif mode == 2:
		# player is on ground and is near
		if rng.randi_range(1, 2) == 1 && player.position.y > -850:
			current_state = BOSS_STATE.KICK
		else:
			current_state = BOSS_STATE.FLY
	elif mode == 3:
		# player is on ground and is far
		var num = rng.randi_range(1, 3)
		if num == 1 and not fire_initialised:
			current_state = BOSS_STATE.SPIT
		elif num == 2:
			current_state = BOSS_STATE.DASH
		else:
			current_state = BOSS_STATE.FLY
	elif mode == 4:
		current_state = BOSS_STATE.FLYBACK
	elif mode == 5: # spit fire on air and continue flying
		current_state = BOSS_STATE.FLY
	elif mode == 6: # mode 6 dash back
		current_state = BOSS_STATE.DASH
	elif mode == 7:
		current_state = BOSS_STATE.SPIT_ON_AIR

