extends Node

#const TIME_PERIOD = 0.1

var time_accuracy

var notes

var note_numb: float = 0

var stage_time = 0

var interval = 0

var total_notes: float  = 0



var y_offset = 800

func _on_music_controller_processed_json() -> void:
	$SpawnManager.tpb = $MusicController.tpb
	$SpawnManager.timesig_numerator = $MusicController.time_signature_numerator
	time_accuracy = $MusicController.time_accuracy
	notes = $MusicController.notes
	total_notes = $MusicController.total_notes


func _ready() -> void:
	# Start Audio
	$MusicController.play_with_delay(4)
	
	# Start Visual
	$Timer.start(time_accuracy)
	
	if notes.has("0"):
		$SpawnManager.spawn_letter(notes["0"])
	


func _process(delta):
	stage_time += delta




func _on_timer_timeout() -> void:
	var current_time = str(snapped(stage_time, time_accuracy))
	
	if notes.has(current_time):
		$SpawnManager.spawn_letter(notes[current_time])
		
		note_numb += 1
		#print("TIME %s, PITCH %d, NOTE NUMB: %d" % [current_time, notes[current_time], note_numb])
	#else:
		#print("---------------")
		
	$GUI/TopBar/ProgressBar.value = note_numb/total_notes * 100
	print("Progress:%d/%d * 100 = %d" % [note_numb, total_notes, (note_numb/total_notes * 100)])
