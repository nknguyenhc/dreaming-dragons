extends StaticBody2D

var health = 10
var prev_frame_health = health
var hurt_animation


func _ready():
	hurt_animation = get_parent().get_node("HurtAnimation")
	hurt_animation.hide()


func _process(delta):
	if prev_frame_health != health:
		hurt_animation.play()
		hurt_animation.show()
		prev_frame_health = health
	if health <= 0:
		queue_free()
		hurt_animation.queue_free()


func _on_HurtAnimation_animation_finished():
	hurt_animation.stop()
	hurt_animation.hide()
