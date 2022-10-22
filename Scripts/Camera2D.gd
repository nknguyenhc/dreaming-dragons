extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().get_parent().get_node("Player").position.x - position.x > 900:
		global_position.x = get_parent().get_parent().get_node("Player").global_position.x - 900
	if get_parent().get_parent().get_node("Player").position.x - position.x < -900:
		global_position.x = get_parent().get_parent().get_node("Player").global_position.x + 900
