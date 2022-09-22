extends Area2D


# Declare member variables here. Examples:
const DAMAGE = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Punch_body_entered(body):
	if body.name == 'Dragon':
		body.health -= DAMAGE


func _animation_done(animated_sprite):
	queue_free()
	get_parent().player_freeze = false # allow the player to move when the skill movement is done
