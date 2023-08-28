extends Node2D

var bar: int = 1
var count: int = 0

func _ready() -> void:
	pass

func spawn_letter(pitch) -> void:
	count += 1
	
	var pitch_str = str(pitch)
	$Letter.set_character(pitch_str)
