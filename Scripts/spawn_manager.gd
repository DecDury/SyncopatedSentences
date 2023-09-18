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

# Letter punctuality
enum {miss, early, perfect, late}
signal tooLate

func _enter_tree() -> void:
	# Set spacing of target zones
	# and set spawn zones relative to them
	var offset = 0
	for t in $Targets.get_children():
		t.position.x += offset
		offset += target_spacing
		spawn_zone_positions.append(Vector2(t.position.x, letter_starting_y))


func _ready() -> void:
	letter_speed = -1 * (letter_starting_y)/(tpb * 4)
	print("Letter Speed: %f" % letter_speed)
	

func spawn_letter(pitch) -> Node2D:
	
	# Instantiate Letter
	var letter_instance = Letter.instantiate()
	
	# Set letter speed
	letter_instance.speed = letter_speed
		
	# Set letter character based on pitch
	letter_instance.set_character(
		KeyboardMapping.getLetter(pitch)
	)
	
	# Set spawn position
	var horizontal_offset = (pitch - KeyboardMapping.min_pitch) / KeyboardMapping.pitch_range * 10 - 1
	letter_instance.global_position = spawn_zone_positions[horizontal_offset]
	
	#
	$LetterContainer.add_child(letter_instance)
	return letter_instance
	
	

#-------------------------
# Area 2D signal handlers
#-------------------------
func _on_late_zone_area_exited(area: Area2D) -> void:
	# letter was missed and should be free
	var letter = area.get_parent()
	print("%s freed" % letter.name)
	$LetterContainer.remove_child(letter)
	letter.queue_free()
	
	# let other nodes know a letter has been missed and the score should be decremented
	emit_signal("tooLate") 
