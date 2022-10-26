extends Control


var texts_displayed
var current_text
var N_TEXTS
const FRAMES_DELAY = 5
var frame_count


func _ready():
	texts_displayed = 0
	frame_count = 0
	current_text = get_child(0)
	N_TEXTS = get_child_count()


func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		if current_text.percent_visible >= 0.9999:
			current_text.percent_visible = 0
			texts_displayed += 1
			if texts_displayed == N_TEXTS:
				get_parent().get_parent().get_tree().paused = false
				queue_free()
			else:
				current_text = get_child(texts_displayed)
		else:
			current_text.percent_visible = 0.9999
	else:
		if frame_count == FRAMES_DELAY:
			current_text.visible_characters += 1
			frame_count = 0
		else:
			frame_count += 1
