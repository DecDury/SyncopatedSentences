extends Node

@export var midi_file: String = "res://Scenes/LEAP.json"

var notes = {}
var time_accuracy: float = 0.000001
var note_numb: int = 0
var total_notes: int = 0
var last_timestamp: float

var bpm: float # beats per minute of the song
var tpb: float # time per beat in seconds
var music_start_time: int = 0 # scene time in msec when music started
var song_position_msec: int # song position in msecs
var song_position: float # song position in secs
var positionInBeats: int # song position in beats
var time_signature_numerator
var time_signature_denominator

signal processed_json
signal song_finished

#------------------
# Song Selection
#------------------
	# 1: LEAP
	# track 21 for bass

	# 2: BOSS battle 2
	# track 12 for Raita 1

	# 3: Final Boss Battle 6
	# track 3 for guitar

var song_number = 3
var time_scale: float = 0.8


func _enter_tree() -> void:
	
	var track_number = 0
	var music_wav
	
	# Select Midi file and complementary wav file
	match song_number:
		1:
			### Need to remove this song ###
			### Midi file may be faulty ###
			midi_file = "res://Audio/Music/LEAP.json"
			track_number = 21 # bass
			music_wav = preload("res://Audio/Music/WAVs/leap.WAV")
			
		2:
			midi_file = "res://Audio/Music/boss_battle_#2.json"
			track_number = 7
			music_wav = preload("res://Audio/Music/WAVs/boss_battle_#2.WAV")
		3:
			midi_file = "res://Audio/Music/FinalBossBattle6.json"
			track_number = 3
			music_wav = preload("res://Audio/Music/WAVs/Final Boss Battle 6 V2.WAV")
	
	$Audio.stream = music_wav
	$Audio.pitch_scale = time_scale
	# reading json file
	process_json(track_number)
	
func process_json(track_number: int) -> void:
	var file = FileAccess.open(midi_file, FileAccess.READ)
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
	bpm = music_json["header"]["tempos"][0]["bpm"]
	time_signature_numerator = music_json["header"]["timeSignatures"][0]["timeSignature"][0]
	time_signature_denominator = music_json["header"]["timeSignatures"][0]["timeSignature"][1]
	tpb = 60/bpm * (1/time_scale) #time per beat in seconds adjusted for time scale
	
	print("Song Info\nBPM=%f\nTPB=%f\nTimeSignature=%d/%d" % [bpm, tpb, time_signature_numerator, time_signature_denominator])
	print("--------------------")
	
	
	var track = music_json["tracks"][track_number]
	var min_pitch = track["notes"][0]["midi"]
	var max_pitch = track["notes"][0]["midi"]
	
	var prev_time = track["notes"][0]["time"]
	var smallest_interval: float = track["notes"][1]["time"]
	for note in track["notes"]:
		add_note_to_array(note)
		
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
	
	# find last time stamp
	last_timestamp = track["notes"][-1]["time"] # -1 gets last index
	
	print("Last Timestamp: %f" % last_timestamp)
	print("Accuracy: %f" % time_accuracy)
	print("Total Notes: %d" % total_notes)
	
	KeyboardMapping.min_pitch = min_pitch
	KeyboardMapping.max_pitch = max_pitch
	KeyboardMapping.pitch_range = max_pitch - min_pitch
	
	# let other nodes know json has been processed
	emit_signal("processed_json")

	
func _physics_process(_delta: float) -> void:
	song_position_msec = $Audio.get_playback_position() * 1000 # seconds to msecs
	
	
func add_note_to_array(note):
	# { "duration": 0.193548, "durationTicks": 240, "midi": 30, "name": "F#1", "ticks": 73680, "time": 59.419236, "velocity": 0.74803149606299 }
	
	# seconds to msec and modify time scale
	var msecs: int = note["time"] * 1000 * (1/time_scale) 
	#print(msecs)
	if !notes.has(msecs):
		notes[msecs] = note["midi"]
		#print("NOTES: %f, %d"% [time, notes[time]])]
		
		# tally note
		total_notes += 1



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
		
		play_music()
	else:
		$StartTimer.start(tpb * beats)
		
func play_music() -> void:
	$Audio.play()
	music_start_time = Time.get_ticks_msec()
	print("Music Start Time: %d" % music_start_time)
	

func _on_timer_timeout() -> void:
	play_music()

func _on_audio_finished() -> void:
	$EndTimer.start(tpb * 1)


func _on_end_timer_timeout() -> void:
	emit_signal("song_finished") # listened to by stage to spawn stats UI


func _on_stage_pause() -> void:
	song_position = $Audio.get_playback_position()
	$Audio.stop()


func _on_stage_play() -> void:
	$Audio.play(song_position)
