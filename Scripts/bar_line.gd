extends Node2D

@export var speed: float = 1.0

#-------------------------
# Physics and Position
#-------------------------
func _physics_process(delta: float) -> void:
	global_position.y += speed * delta
