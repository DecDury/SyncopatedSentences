extends Node

var min_pitch
var max_pitch
@export var number_of_letters: float = 30
@export var number_of_cols: float = 10
var pitch_range

var col_to_let_ratio: float = number_of_cols/number_of_letters



var vert_mapping = [
	"zaq", # 0
	"xsw", # 1
	"cde", # 2
	"vfr", # 3
	"bgt", # 4
	"nhy", # 5
	"mju", # 6
	",ki", # 7
	".lo", # 8
	"/;p"  # 9
]

var horiz_mapping = [
	"qwertyuiop", # 1
	"asdfghjkl;", # 2
	"zxcvbnm,./" # 3
]

func getLetter(pitch: int) -> String:
	
	pitch_range = max_pitch - min_pitch
	var let_to_pit_ratio = number_of_letters / (pitch_range+1)
	var mapped_letter_index: int = let_to_pit_ratio * (pitch - min_pitch)
	
	print("Pitch Range: %f" % pitch_range)
	print("Mapped Letter Index: %f" % mapped_letter_index)
	
		
	var letter = vert_mapping[mapped_letter_index / 3][mapped_letter_index % 3]
	letter = letter.to_upper()
	
	#print("MAPPED Pitch:%d -> Letter:%s" % [pitch, letter])
	return letter

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
	
func getIndexForCollumn(character: String) -> int:
	# returns index if found, -1 if unsuccessful
	var current_index: int = 0
	var index: int = -1
	for col in vert_mapping:
		for letter in col:
			if letter.to_upper() == character:
				index = current_index
				break
		current_index += 1
	return index
	
func getLetterForRow(row: int) -> String:
	var rowString = horiz_mapping[0]
	if row >= horiz_mapping.size():
		print("Row Number: out of bounds, got %d" % row)
		return "%d" % row
	else:
		rowString = horiz_mapping[row]
		var letterIndex = randi() % rowString.length()
		var letter = rowString[letterIndex]
		return letter
	
	
