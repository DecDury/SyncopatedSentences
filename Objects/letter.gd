extends Node2D

@export var speed: float = 1.0
var prev_speed: float = 1.0

enum {miss, early, perfect, late}
var punctuality: int = miss

#-------------------------
# text component
#-------------------------
func set_character(inputChar):
	$text.text = inputChar

func get_character() -> String:
	return $text.text
	
func set_punctuality(time: int):
	punctuality = time

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



