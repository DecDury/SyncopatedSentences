extends Node

var notes = {}
var time_accuracy = 0.000001
var note_numb = 0
var total_notes = 0

var tempo
var time_signature_numerator
var time_signature_denominator
var tpb: float

var music_start_time: int = 0

signal processed_json

func _enter_tree() -> void:
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
	tempo = music_json["header"]["tempos"][0]["bpm"]
	time_signature_numerator = music_json["header"]["timeSignatures"][0]["timeSignature"][0]
	time_signature_denominator = music_json["header"]["timeSignatures"][0]["timeSignature"][1]
	tpb = 60/tempo #time per beat in seconds
	
	print("Song Info\nBPM=%d\nTPB=%f\nTimeSignature=%d/%d" % [tempo, tpb, time_signature_numerator, time_signature_denominator])
	
	
	var track = music_json["tracks"][21] # bass
	var min_pitch = track["notes"][0]["midi"]
	var max_pitch = track["notes"][0]["midi"]
	
	var prev_time = track["notes"][0]["time"]
	var smallest_interval: float = track["notes"][1]["time"]
	for note in track["notes"]:
		add_note_to_array(note)
		
		# tally note
		total_notes += 1
		
		# find pitch range
		if note["midi"] < min_pitch:
			min_pitch = note["midi"]
		if note["midi"] > max_pitch:
			max_pitch = note["midi"]
			
		# find smallest note interval
		var diff = note["time"] - prev_time
		if smallest_interval > diff && diff != 0:
			smallest_interval = diff
		prev_time = note["time"]
		
	
	print("LowestPitch=%d\nHighestPitch=%d" % [min_pitch, max_pitch])
	print("Smallest Interval: %f" % smallest_interval)
	
	# Set smallest interval to time_accuracy
	#time_accuracy = snapped(smallest_interval, 0.001)
	
	print("Accuracy: %f" % time_accuracy)
	
	KeyboardMapping.min_pitch = min_pitch
	KeyboardMapping.max_pitch = max_pitch
	KeyboardMapping.pitch_range = max_pitch - min_pitch
	
	# let other nodes know json has been processed
	emit_signal("processed_json")
		
	
func add_note_to_array(note):
	# { "duration": 0.193548, "durationTicks": 240, "midi": 30, "name": "F#1", "ticks": 73680, "time": 59.419236, "velocity": 0.74803149606299 }
	var msecs = snapped(note["time"] * 1000, 1) # seconds to msec
	#print(msecs)
	if !notes.has(msecs):
		notes[msecs] = note["midi"]
		#print("NOTES: %f, %d"% [time, notes[time]])

func play_with_delay(beats: int):
	print("play with delay called - %f" % (tpb * beats))
	
	var with_timer = true
	if (!with_timer):
		var delay_in_msec = tpb * beats * 1000
		var start_time: int = Time.get_ticks_msec()
		var current_time: int =  start_time
		while(current_time - start_time < delay_in_msec):
			print("Intro: %d" % (current_time - start_time))
			current_time = Time.get_ticks_msec()
		
		$Audio.play()
		music_start_time = Time.get_ticks_msec()
		print("Music Start Time: %d" % music_start_time)
	else:
		$Timer.start(tpb * beats)
	

func _on_timer_timeout() -> void:
	$Audio.play()
	music_start_time = Time.get_ticks_msec()
	print("Music Start Time: %d" % music_start_time)
	
func play_note(stage_time) -> float:
	var current_time = snapped(stage_time, time_accuracy)
	
	if notes.has(str(current_time)):
		return current_time
	else:
		return 0

