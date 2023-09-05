extends Node

#const TIME_PERIOD = 0.1

var time_accuracy

var notes

var note_numb = 0

var stage_time = 0

var interval = 0



var y_offset = 800

func _on_music_controller_processed_json() -> void:
	$SpawnManager.tpb = $MusicController.tpb
	$SpawnManager.timesig_numerator = $MusicController.time_signature_numerator


func _ready() -> void:
	time_accuracy = $MusicController.time_accuracy
	notes = $MusicController.notes
	$MusicController.play_with_delay(4)
	


func _process(delta):
	stage_time += delta
	interval += delta
	if interval >= time_accuracy:
		var current_time = $MusicController.play_note(stage_time)
		if current_time:
			current_time = str(current_time)
			
			
			$SpawnManager.spawn_letter(notes[current_time])
			
			note_numb += 1
			print("TIME %s, PITCH %d, NOTE NUMB: %d" % [current_time, notes[current_time], note_numb])
		else:
			print("---------------")
			
		# Reset timer
		interval = 0


