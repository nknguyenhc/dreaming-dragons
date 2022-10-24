extends Node2D

var slime_count = 7

var map

func _ready():
	map = get_node("Map1")
	
	get_node("slime9").health = 10	
	get_node("slime10").health = 10
	get_node("slime11").health = 10
	get_node("slime12").health = 10
	get_node("slime9").decrement = 0	
	get_node("slime10").decrement = 0	
	get_node("slime11").decrement = 0
	get_node("slime12").decrement = 0

	get_node("bat2").add_on = 1
	get_node("bat3").add_on = 2
	
	map.get_node("spike5").damage = 30
	map.get_node("spike7").damage = 20
	map.get_node("thorn").damage = 30
	
	
	
	map.get_node("mp1-2").max_t = 1.5
	map.get_node("mp2-1").max_t = 1
	map.get_node("mp2-1").speed = 300
	map.get_node("mp3-1").is_vertical = true
	map.get_node("mp3-1").speed = 50
	map.get_node("mp3-2").is_vertical = true
	map.get_node("mp3-2").speed = 50
	map.get_node("mp3-2").max_t = 1.6
	map.get_node("mp3-3").is_vertical = true
	map.get_node("mp3-3").speed = 50
	map.get_node("mp3-3").max_t= 1.8
	map.get_node("mp4-1").speed = 50
	map.get_node("mp4-1").max_t = 1
	map.get_node("mp3-4").speed = 60
	map.get_node("mp3-4").max_t = 2.2
	map.get_node("mp3-4").is_vertical = true
	map.get_node("mp3-5").speed = 50
	map.get_node("mp3-5").is_vertical = true
	map.get_node("mp4-2").speed = 100
	map.get_node("mp4-2").max_t = 11
	map.get_node("mp2-2").speed = 50
	map.get_node("mp2-2").max_t = 20
	
	
	

func _process(delta):
	if slime_count == 0:
		get_node("blocking").queue_free()
		slime_count -= 1
