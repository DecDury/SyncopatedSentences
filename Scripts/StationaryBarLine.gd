extends Node2D

@onready var defaultScale = scale

func pulse(tpb: float) -> void:
	scale.x = defaultScale.x * 1.2
	scale.y = defaultScale.y * 5
#	$AnimatedSprite2D.animation = "pulse"
	$Timer.start(tpb)


func _on_timer_timeout() -> void:
	scale = defaultScale
#	$AnimatedSprite2D.animation = "white"
