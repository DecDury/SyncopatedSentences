extends Node2D

@onready var starting_sprite = $AnimatedSprite2D.animation

func miss():
	$AnimatedSprite2D.animation = "miss"
	$Timer.start()
	
func hit():
	$AnimatedSprite2D.animation = "hit"
	$Timer.start()


func _on_timer_timeout() -> void:
	# return to default animation after timer runs out
	$AnimatedSprite2D.animation = starting_sprite
