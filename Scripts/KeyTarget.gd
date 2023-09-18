extends Node2D

func miss():
	$AnimatedSprite2D.animation = "miss"
	$Timer.start()
	
func hit():
	$AnimatedSprite2D.animation = "hit"
	$Timer.start()


func _on_timer_timeout() -> void:
	# return to default animation after timer runs out
	$AnimatedSprite2D.animation = "default"
