extends Control

@onready var menu = preload("res://Scenes/menu.tscn")

var oldHighscore: int = 1

func _ready() -> void:
	$VBoxContainer/MenuButton.grab_focus()

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(menu)
	
func calc_stats(score: int , raw_score: float, total_notes: int):
	$PanelContainer/VBoxContainer/Score/Score.set_text(str(score))
	
	# check if score is a new highscore
	if score > oldHighscore:
		$VBoxContainer/NewHighScore/HighScore.set_text(str(score))
		
		# save new highscore 
		# TODO
	
	# calculate accuracy
	# raw score is points without combo multiplier
	# since a perfect hit is worth two points,
	# a flawless score would be worth twice the total number of notes
	$VBoxContainer/Accuracy/Accuracy.set_text( "%.3f%%" % (raw_score/(total_notes * 2)) )
	print("Raw Score: %f\nTotal Notes: %d\n" % [raw_score, total_notes])
