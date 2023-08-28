extends Node

var notes = {}
var time_accuracy = 0.1
var note_numb = 0

var tempo
var time_signature_numerator
var time_signature_denominator
var tpm: float 

func _ready() -> void:
	# reading json file
	var file = FileAccess.open("res://Scenes/LEAP.json",FileAccess.READ)
	var text = file.get_as_text()
	
	var json = JSON.new()
	var error = json.parse(text)
	var music_json
	if error == OK:
		music_json = json.data
	else:
		print(json.get_error_message())
	file.close()
	
	# general info
	var tempo = music_json["header"]["tempos"][0]["bpm"]
	var time_signature_numerator = music_json["header"]["timeSignatures"][0]["timeSignature"][0]
	var time_signature_denominator = music_json["header"]["timeSignatures"][0]["timeSignature"][1]
	var tpm: float = 60/tempo #time per beat in seconds
	
	print("Song Info\nBPM=%d\nTPM=%f\nTimeSignature=%d/%d" % [tempo, tpm, time_signature_numerator, time_signature_denominator])
	
	
	var track = music_json["tracks"][21]
	var min_pitch = track["notes"][0]["midi"]
	var max_pitch = track["notes"][0]["midi"]
	
	for note in track["notes"]:
		add_note_to_array(note)
		
		# find pitch range
		if note["midi"] < min_pitch:
			min_pitch = note["midi"]
		if note["midi"] > max_pitch:
			max_pitch = note["midi"]
	
	print("LowestPitch=%d\nHighestPitch=%d" % [min_pitch, max_pitch])
	
	KeyboardMapping.min_pitch = min_pitch
	KeyboardMapping.max_pitch = max_pitch
		
	
func add_note_to_array(note):
	# { "duration": 0.193548, "durationTicks": 240, "midi": 30, "name": "F#1", "ticks": 73680, "time": 59.419236, "velocity": 0.74803149606299 }
	var time = str(snapped(note["time"], time_accuracy))
	if !notes.has(time):
		notes[time] = note["midi"]

func _on_start_btn_pressed() -> void:

	$Timer.start(time_accuracy)
	
	if notes.has("0"):
		$SpawnManager.spawn_letter(notes["0"])
		$Music.play()


func _on_stop_btn_pressed() -> void:
	$Music.stop()
	$Timer.stop()


func _on_timer_timeout() -> void:
	var current_time = str(snapped($Music.get_playback_position(), time_accuracy))
	
	if notes.has(current_time):
		$SpawnManager.spawn_letter(notes[current_time])
		
		note_numb += 1
		print("TIME %s, PITCH %d, NOTE NUMB: %d" % [current_time, notes[current_time], note_numb])
	else:
		print("---------------")
	
