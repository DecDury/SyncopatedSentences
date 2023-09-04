extends Node2D

# preload letter scene
var Letter = preload("res://Objects/letter.tscn")
#@onready var range = max_pitch - min_pitch


func _ready() -> void:
	pass

func spawn_letter(pitch, position) -> void:
	
	var letter_instance = Letter.instantiate()
	
	letter_instance.set_character(
		KeyboardMapping.getLetter(pitch)
	)
	letter_instance.global_position = position
	
	add_child(letter_instance)
	
	
	
	
