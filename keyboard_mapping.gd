extends Node

var vert_mapping = [
	"qaz",
	"wsx",
	"edc",
	"rfv",
	"tgb",
	"yhn",
	"ujm",
	"ik,",
	"ol.",
	"p;/"
]

var horiz_mapping = [
	"qwertyuiop",
	"asdfghjkl;",
	"zxcvbnm,./"
]

func getLetterForColumn(col: int) -> String:
	var colString = vert_mapping[0]
	if col >= vert_mapping.size():
		print("Column Number: out of bounds, got %d" % col)
		return "%d" % col
	else:
		colString = vert_mapping[col]
		var letterIndex = randi() % colString.length()
		var letter = colString[letterIndex]
		letter = letter.to_upper()
		print("Column Letter: %s" % letter)
		return letter
	
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
	
	
