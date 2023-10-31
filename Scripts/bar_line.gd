extends Node2D

@export var speed: float = 1.0


func set_punctuality(_time: int): # 
	pass
#-------------------------
# Physics and Position
#-------------------------
func _physics_process(delta: float) -> void:
	global_position.y += speed * delta
