extends Node

var notes = {}
var time_accuracy = 0.1

func _ready() -> void:
	# reading json file
	var file = FileAccess.open("res://Scenes/LEAP.json",FileAccess.READ)
	var text = file.get_as_text()
	
	var json = JSON.new()
	var error = json.parse(text)
	if error == OK:
		var music_json = json.data
		if typeof(music_json) == TYPE_ARRAY:
			print(music_json)
		else:
			print("Not an array")
	file.close()
	
	#for track in music_json["tracks"]:
		#for note in track["notes"]:
			#print(note)
			

func _on_start_btn_pressed() -> void:
	$Music.play()


func _on_stop_btn_pressed() -> void:
	$Music.stop()
