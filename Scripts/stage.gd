extends Node

#const TIME_PERIOD = 0.1

var time_accuracy
var visual_start_time: int

var notes
var note_times = []
var note_numb: float = 0
var beat_numb_since_checkpoint: int = 0
var stage_time = 0
var interval = 0
var tpb_msec: int
var next_bar_time: int
var bar_check_point: int
var total_notes: float  = 0

var beat_time = 0

var score: int = 0
var raw_score: float = 0
var combo_multiplier: int = 1
enum {miss, early, perfect, late}

var Letter = preload("res://Objects/letter.tscn")

@onready var targets = $SpawnManager/Targets
@onready var punctuality_GUI_label = $GUI/RightBar/VBoxContainer/PunctualityQualifier
@onready var score_label = $GUI/LeftBar/HBoxContainer/ScoreBox/Score/ScorePoints
@onready var combo_label = $GUI/LeftBar/HBoxContainer/ScoreBox/Combo/ComboMultiplier
@onready var progress_bar = $GUI/TopBar/ProgressBar

func _on_music_controller_processed_json() -> void:
	$SpawnManager.tpb = $MusicController.tpb
	$SpawnManager.timesig_numerator = $MusicController.time_signature_numerator
	
	tpb_msec = $MusicController.tpb * 1000
	time_accuracy = $MusicController.time_accuracy
	
	notes = $MusicController.notes
	note_times = notes.keys()
	print("---------------\nNote Times\n%s\n---------------" % notes)
	total_notes = $MusicController.total_notes


func _ready() -> void:
	
	# Start Audio
	$MusicController.play_with_delay(4)
#	$MusicController.play_music()
	
	# Start Visual
	#$Timer.start(time_accuracy)
	visual_start_time = Time.get_ticks_msec()
	next_bar_time = visual_start_time
	print("Next Bar Time: %f" % next_bar_time)
#	$SpawnManager.spawn_barline()
	print("Visual Start Time: %d" % visual_start_time)
	#print(note_times)
	
func _process(_delta: float) -> void:
	score_label.set_text(str(score))
	combo_label.set_text(str(combo_multiplier))

func _physics_process(delta: float) -> void:
	stage_time += delta
	
	var current_time = Time.get_ticks_msec() - visual_start_time
	var pitch
	var note_time
	
	if (note_numb >= total_notes): # prevents index out of bounds
		return
	
	note_time = note_times[note_numb]
	
	# Spawn letter
	if (current_time >= note_time):
		print("---------- Note - %s ----------" % note_numb)
		#print("NoteTime: %d / Diff Between Beat: %d" % [current_time, current_time - beat_time])
		
		pitch = notes[note_time]
		$SpawnManager.spawn_letter(pitch)
		
		# Update progess bar
		progress_bar.value = note_numb/total_notes * 100
		
		#print( "CurrentTime: %d / NoteTime: %d / Diff: %d" % [current_time, note_times[note_numb], current_time - note_times[note_numb]] )
		#print("Song Position: %d / Diff: %d" % [$MusicController.song_position, current_time - $MusicController.song_position])
		note_numb += 1
		
		if (note_time % tpb_msec <= tpb_msec/4): # vague within 16th note accuracy
			# note occurs on beat
			# thus bar and note spawn at same time
			print("---------------- Beat with Letter -------- %d --------" % current_time)
			$SpawnManager.spawn_barline()
			bar_check_point = note_time
			next_bar_time = bar_check_point + tpb_msec
			beat_numb_since_checkpoint = 0
			return
	
	# Spawn barline
	if (current_time >= next_bar_time):
		beat_numb_since_checkpoint += 1
		beat_time = current_time
		print("---------------- Beats since checkpoint - %s -------- %d --------" % [beat_numb_since_checkpoint, current_time])
	
		$SpawnManager.spawn_barline()
#		next_bar_time = visual_start_time + beat_numb * tpb_msec
		next_bar_time = bar_check_point + tpb_msec * beat_numb_since_checkpoint
		
		



func _on_timer_timeout() -> void:
	# every (time_accuracy) seconds, check if there is a note at that timestamp
	var current_time = str(snapped(stage_time, time_accuracy))
#	spawn_letter_on_time(current_time)



func _input(event: InputEvent) -> void:
	var typed_event: InputEventKey
	var key_typed: String

	if event is InputEventKey and not event.is_pressed():
		typed_event = event as InputEventKey
		key_typed = typed_event.as_text()
		key_typed = KeyboardMapping.check_if_special_character(key_typed)
		print("INPUT: " + key_typed)
	
		# Get target index for leter miss or hit animation
		var target_index = KeyboardMapping.getIndexForCollumn(key_typed)
		if target_index < 0:
			print("!!! Invalid Keystroke !!!")
			return
		
		var target = targets.get_child(target_index)
		
		var letter = $SpawnManager/LetterContainer.get_child(0)
		if letter != null:
			if letter.get_character() == key_typed:
				# determine punctuality
				match letter.punctuality:
					miss:
						# Right letter, wrong time
						combo_multiplier = 1 # reset combo multiplier
						raw_score -= 2
						score -= 2 * combo_multiplier
						target.miss() # play miss animation
						punctuality_GUI_label.set_text("Miss")
						#print("MISS")
					early:
						raw_score += 1
						score += 1 * combo_multiplier
						punctuality_GUI_label.set_text("Early")
						#print("EARLY")
					perfect:
						raw_score += 2
						score += 2 * combo_multiplier
						punctuality_GUI_label.set_text("Perfect!!!")
						#print("PERFECT")
					late:
						raw_score += 1
						score += 1 * combo_multiplier
						punctuality_GUI_label.set_text("Late")
						#print("LATE")
				print("%s" % key_typed)
				
				
				if letter.punctuality != miss:
					if combo_multiplier < 9:
						combo_multiplier += 1
						
					target.hit() # play hit animation
						
					# free
					letter.queue_free()
			else:
				# wrong letter
				punctuality_GUI_label.set_text("Miss")
				score -= 2 * combo_multiplier
				combo_multiplier = 1
				target.miss() # play miss animation
				#print("MISS")


func _on_spawn_manager_too_late(node) -> void:
	# Letter missed target zone and score should be decremented
	combo_multiplier = 1 # reset combo multiplier
	score -= 2 * combo_multiplier


func _on_spawn_manager_deadcenter() -> void:
#	if (node)
	pass # Replace with function body.


func _on_music_controller_song_finished() -> void:
	var stats = load("res://Scenes/stage_stats.tscn").instantiate()
	stats.calc_stats(score, raw_score, total_notes)
	add_child(stats)
	
	
