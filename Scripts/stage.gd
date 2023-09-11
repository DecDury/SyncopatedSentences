extends Node

#const TIME_PERIOD = 0.1

var time_accuracy
var notes
var note_numb: float = 0
var stage_time = 0
var interval = 0
var total_notes: float  = 0

var score: int = 0
enum {miss, early, perfect, late}

var Letter = preload("res://Objects/letter.tscn")

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
	# every (time_accuracy) seconds, check if there is a note at that timestamp
	var current_time = str(snapped(stage_time, time_accuracy))
	
	if notes.has(current_time):
		# if so, spawn letter
		$SpawnManager.spawn_letter(notes[current_time])
		
		note_numb += 1
		
		# update progress bar position with each note
		$GUI/TopBar/ProgressBar.value = note_numb/total_notes * 100
		#print("Progress:%d/%d * 100 = %d" % [note_numb, total_notes, (note_numb/total_notes * 100)])
		
		#print("TIME %s, PITCH %d, NOTE NUMB: %d" % [current_time, notes[current_time], note_numb])
	#else:
		#print("---------------")

func check_if_special_character(typed_character: String) -> String:
	match typed_character:
		"Semicolon":
			typed_character = ";"
		"Comma":
			typed_character = ","
		"Period":
			typed_character = "."
		"Slash":
			typed_character = "/"
	
	return typed_character

func _input(event: InputEvent) -> void:
	var typed_event: InputEventKey
	var key_typed: String
	
	if event is InputEventKey:
		typed_event = event as InputEventKey
		key_typed = typed_event.as_text()
		key_typed = check_if_special_character(key_typed)
		#print("INPUT: " + key_typed)
		
		for letter in $SpawnManager.letters_in_zone:
			if letter.get_character() == key_typed:
			
				# determine punctuality
				match letter.punctuality:
					miss:
						score -= 2
						print("MISS")
					early:
						score += 1
						print("EARLY")
					perfect:
						score += 2
						print("PERFECT")
					late:
						score += 1
						print("LATE")
				print("%d" % key_typed)
				
				# free letter
				$SpawnManager.letters_in_zone.erase(letter)
				letter.queue_free()
				break
