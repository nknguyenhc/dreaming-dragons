extends Control

var level1

# Called when the node enters the scene tree for the first time.
func _ready():
	level1 = get_parent().get_parent().get_parent()


func _on_from_begin_button_up():
	level1.get_node("Player").invincible = false
	level1.restart()

func _on_from_save_point_button_up():
	level1.get_node("Player").invincible = false

func _on_cancel_button_up():
	level1.get_node("Player").invincible = false
	queue_free()
