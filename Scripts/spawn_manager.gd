extends Node2D

# preload letter scene
@export var Letter = preload("res://Objects/letter.tscn")
@export var Barline = preload("res://Scenes/bar_line.tscn")

var target_spacing = 128
var letter_starting_y = -950 # relative to location of spawn manager node
var beat_offset: int = 4 # number of beats from spawn to target zones

# should be set by stage script
var tpb: float = 1
var timesig_numerator: int = 4
var number_of_targets: int = 0

var spawn_zone_positions = []
var barline_spawn_position: Vector2
var letter_speed

# Letter punctuality
enum {miss, early, perfect, late}
signal tooLate
signal pause
signal play

func _enter_tree() -> void:
	# Set spacing of target zones
	# and set spawn zones relative to them
	var offset = 0
	for t in $Targets.get_children():
		number_of_targets += 1
		t.position.x += offset
		offset += target_spacing
		spawn_zone_positions.append(Vector2(t.position.x, letter_starting_y))
		
	# determine center point for barline spawn
	var centered_xposition
	if (number_of_targets % 2 == 0): # number of targets is even
		var mid_right_index = number_of_targets/2
		var mid_left_index = mid_right_index - 1
		
		var mid_right_position = spawn_zone_positions[mid_right_index]
		var mid_left_position = spawn_zone_positions[mid_left_index]
		centered_xposition = (mid_right_position.x - mid_left_position.x) / 2 + mid_left_position.x
		
		print("MidLeftPosition: %s" % mid_left_position)
		print("MidRightPosition: %s" % mid_right_position)
		print("Centered_XPosition: %s" % centered_xposition)
	else: # number of targets is odd
		var center_index = number_of_targets/2 + 1
		
		var center_position = spawn_zone_positions[center_index]
		centered_xposition = center_position.x
		
	barline_spawn_position = Vector2(centered_xposition, letter_starting_y)
	print("Barline Spawn Position: %s" % barline_spawn_position)
	print("-------------------------")
		


func _ready() -> void:
	letter_speed = -1 * (letter_starting_y)/(tpb * beat_offset)
	print("Letter Speed: %f" % letter_speed)
	
func spawn_barline() -> Node2D:
	
	# Instantiate Barline
	var barline_instance = Barline.instantiate()
	
	# Set barline speed
	barline_instance.speed = letter_speed
	
	# Set spawn position
	barline_instance.global_position = barline_spawn_position
	
	$BarlineContainer.add_child(barline_instance)
	
	#print("Spawn Barline Called")
	
	return barline_instance
	

func spawn_letter(pitch) -> Node2D:
	
	# Instantiate Letter
	var letter_instance = Letter.instantiate()
	
	# Set letter speed
	letter_instance.speed = letter_speed
	
	# Set letter character based on pitch
	var letter_char = KeyboardMapping.getLetter(pitch)
	letter_instance.set_character(letter_char)
	
	# Set spawn position
	letter_instance.global_position = spawn_zone_positions[KeyboardMapping.getLastColIndex()]
#	print("LetterCol: %d for %s" % [KeyboardMapping.getLastColIndex(), letter_char])
	
	#
	$LetterContainer.add_child(letter_instance)
	return letter_instance
	
	

#-------------------------
# Area 2D signal handlers
#-------------------------
func _on_early_zone_area_entered(area: Area2D) -> void:
	var letter_node = area.get_parent()
	if letter_node.name.contains("Letter"):
		letter_node.set_punctuality(early)


func _on_perfect_zone_area_entered(area: Area2D) -> void:
	var letter_node = area.get_parent()
	if letter_node.name.contains("Letter"):
		letter_node.set_punctuality(perfect)


func _on_late_zone_area_entered(area: Area2D) -> void:
	var letter_node = area.get_parent()
	if letter_node.name.contains("Letter"):
		letter_node.set_punctuality(late)


func _on_late_zone_area_exited(area: Area2D) -> void:
	
	# node passed targetzones and should be freed
	var node = area.get_parent() # letter or barline
	#print("Late Zone Exited: %s" % node.name)
	#print("%s freed" % letter.name)
	
	# let other nodes know a letter has been missed and the score should be decremented
#	emit_signal("tooLate")
	if (node.name.contains("Letter")):
		tooLate.emit(node)
	
	node.queue_free()
	
	

func _on_collision_shape_barline_area_entered(area: Area2D) -> void:
	var barline_node = area.get_parent()
	if barline_node.name.contains("BarLine"):
		barline_node.queue_free()


func _on_stage_pause() -> void:
	pass


func _on_stage_play() -> void:
	pass # Replace with function body.
