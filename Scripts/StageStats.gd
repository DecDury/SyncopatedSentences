extends Control

@onready var menu_container = preload("res://Scenes/menu_container.tscn")

var oldHighscore: int = 1

func _ready() -> void:
	var menu_button = $PanelContainer/VBoxContainer/MenuButton
	menu_button.grab_focus()


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(menu_container)
	
func calc_stats(score: int , raw_score: float, total_notes: int, song_number: int, time_scale: float):
	var score_label = $PanelContainer/VBoxContainer/Score/Score
	var accuracy_label = $PanelContainer/VBoxContainer/Accuracy/Accuracy
	var previous_high_score_label = $PanelContainer/VBoxContainer/PreviousHighScore/HighScore
	var time_scale_label = $PanelContainer/VBoxContainer/TimeScale/TimeScale
	if time_scale != 1:
		$PanelContainer/VBoxContainer/TimeScale.visible = true
		time_scale_label.set_text("%.2f" % time_scale)
		
	
	score_label.set_text(str(score))
	
	oldHighscore = Save.load_score(song_number, time_scale)
	print("Old High Score: %d" % oldHighscore)
	
	if oldHighscore > 0:
		$PanelContainer/VBoxContainer/PreviousHighScore.visible = true
		previous_high_score_label.set_text(str(oldHighscore))
	
	# check if score is a new highscore
	if score > oldHighscore:
		var high_score_label = $PanelContainer/VBoxContainer/NewHighScore/HighScore
		
		# hide score label and replace with "New High Score!!!"
		$PanelContainer/VBoxContainer/Score.visible = false
		$PanelContainer/VBoxContainer/PreviousHighScore.visible = true
		$PanelContainer/VBoxContainer/NewHighScore.visible = true
		
		high_score_label.set_text(str(score))
		
		# save new highscore
		Save.save_score(song_number, time_scale, score)
		
	
	# calculate accuracy
	# raw score is points without combo multiplier
	# since a perfect hit is worth two points,
	# a flawless score would be worth twice the total number of notes
	accuracy_label.set_text( "%.3f%%" % (raw_score/(total_notes * 2)) )
	print("Raw Score: %f\nTotal Notes: %d\n" % [raw_score, total_notes])
	
	# So all items appear at the same time
	$PanelContainer.visible = true
