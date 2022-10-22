extends Area2D


# Declare member variables here. Examples:
const DAMAGE = 8


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Kick_body_entered(body):
	if body.get_collision_layer() == 2:
		body.health -= DAMAGE
