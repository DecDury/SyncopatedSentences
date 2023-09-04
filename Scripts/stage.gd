extends Node

#const TIME_PERIOD = 0.1

var time_accuracy

var notes

var note_numb = 0

var time = 0

var spawn_zone_positions = []

var y_offset = 1200

func _ready() -> void:
	time_accuracy = $MusicController.time_accuracy
	notes = $MusicController.notes
	for tz in $GUI/BottomBar/HBoxContainer/Targets.get_children():
		spawn_zone_positions.append(Vector2(tz.global_position.x, tz.global_position.y - y_offset))

func _process(delta):
	time += delta
	if time > time_accuracy:
		var current_time = $MusicController.play_note()
		if current_time:
			current_time = str(current_time)
			
			var horizontal_offset = (notes[current_time] - KeyboardMapping.min_pitch) / KeyboardMapping.pitch_range * 10 - 1
			
			$SpawnManager.spawn_letter(notes[current_time], spawn_zone_positions[horizontal_offset])
			
			note_numb += 1
			print("TIME %s, PITCH %d, NOTE NUMB: %d" % [current_time, notes[current_time], note_numb])
		else:
			print("---------------")
			
		# Reset timer
		time = 0


