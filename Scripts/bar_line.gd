extends Node2D

@export var speed: float = 1.0
var prev_speed: float = 1.0


func set_punctuality(_time: int): # 
	pass
#-------------------------
# Physics and Position
#-------------------------
func _physics_process(delta: float) -> void:
	global_position.y += speed * delta
	
func pause() -> void:
	prev_speed = speed
	speed = 0
	
func play() -> void:
	speed = prev_speed
