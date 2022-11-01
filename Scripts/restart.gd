extends WindowDialog

var level1

# Called when the node enters the scene tree for the first time.
func _ready():
	level1 = get_parent().get_parent()

func open():
	show()


func _on_from_begin_pressed():
	get_tree().paused = false
	level1.get_parent().restart_from_mode_selection()


func _on_from_save_point_pressed():
	get_tree().paused = false
	level1.get_parent().restart_from_last_save_point()


func _on_Restart_hide():
	get_tree().paused = false

