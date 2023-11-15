extends Control
#@onready var stage = preload("res://Scenes/stage.tscn")

func _ready() -> void:
	$PanelContainer/VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed() -> void:
	var stage_select = load("res://Scenes/stage_select.tscn")
	get_tree().change_scene_to_packed(stage_select)


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
