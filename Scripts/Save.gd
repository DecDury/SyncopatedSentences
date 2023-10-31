# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game(song_number: int, highscore: int):
	var save_game = FileAccess.open("res://Saves/savegame.save", FileAccess.WRITE)

	# Make new entry
	var entry = {song_number : highscore}

	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(entry)

	# Store the save dictionary as a new line in the save file.
	save_game.store_line(json_string)
