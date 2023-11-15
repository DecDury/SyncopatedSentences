extends Node

var path
var song_number: int = 3
var time_scale: float = 1

func save_score(stage:int, time_scale:float, score:int):
	path = "stage%d-Scale%.2f.txt" % [stage, time_scale]
	var file = FileAccess.open("user://%s" % path, FileAccess.WRITE)
	file.store_64(score)

func load_score(stage:int, time_scale: float):
	path = "stage%d-Scale%.2f.txt" % [stage, time_scale]
	var file = FileAccess.open("user://%s" % path, FileAccess.READ)
	var score: int
	if (file == null):
		score = 0
	else:
		score = file.get_64()
	print("Loaded Score: %d" % score)
	return score
