extends Node2D

# preload letter scene
var Letter = preload("res://Objects/letter.tscn")

var target_spacing = 128
var letter_starting_y = -1100 # relative to location of spawn manager node

# should be set by stage script
var tpb: float = 1
var timesig_numerator = 4

var spawn_zone_positions = []
var letter_speed 
#@onready var range = max_pitch - min_pitch

func _enter_tree() -> void:
	var offset = 0
	for t in $StaticBody2D.get_children():
		t.position.x += offset
		offset += target_spacing
		spawn_zone_positions.append(Vector2(t.position.x, letter_starting_y))


func _ready() -> void:
	letter_speed = -1 * (letter_starting_y)/(tpb * 4)
	print("Letter Speed: %f" % letter_speed)
	

func spawn_letter(pitch) -> void:
	
	var letter_instance = Letter.instantiate()
	
	letter_instance.speed = letter_speed
		
	letter_instance.set_character(
		KeyboardMapping.getLetter(pitch)
	)
	
	
	var horizontal_offset = (pitch - KeyboardMapping.min_pitch) / KeyboardMapping.pitch_range * 10 - 1
	letter_instance.global_position = spawn_zone_positions[horizontal_offset]
	
	add_child(letter_instance)
	
	
	

