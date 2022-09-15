extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2.ZERO
var status = "idle"
var player_bitten = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
# if player is within a certain distance, walk
	if (position.x - get_parent().get_node("player").position.x) < 1000 and status != "walking":
		status = "walking"
		get_node("motions").animation = "walk"
		velocity -= Vector2(200,0)
	# if player is within a very close distance for a cumulated time, bite, if player is in hitbox, -health
	if (position.x - get_parent().get_node("player").position.x) < 200 and status != "biting":
		status = "biting"
		get_node("motions").animation = "bite"
	
	if status == "biting" and player_bitten:
		get_parent().get_node("player").hurt()
	


func _on_mouth_body_entered(body):
	if body == "player":
		player_bitten = true

