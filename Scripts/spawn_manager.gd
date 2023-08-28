extends Node2D

# preload letter scene
var Letter = preload("res://Objects/letter.tscn")
#@onready var range = max_pitch - min_pitch


func _ready() -> void:
	pass

func spawn_letter(pitch) -> void:
	
	var letter_instance = Letter.instantiate()
	
	letter_instance.set_character(
		KeyboardMapping.getLetter(pitch)
	)
	# TODO
	var range = KeyboardMapping.max_pitch - KeyboardMapping.min_pitch
	var horizontal_offset = (pitch - KeyboardMapping.min_pitch) / range * 10 - 1
	letter_instance.global_position = Vector2(horizontal_offset * 40,0)
	
	add_child(letter_instance)
	
	
	
	
