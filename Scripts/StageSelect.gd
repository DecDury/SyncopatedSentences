extends Control

@onready var time_scale_scene = preload("res://Scenes/time_scale.tscn")

func _ready() -> void:
	$PanelContainer/VBoxContainer/Stage1.grab_focus()


func _on_stage_1_pressed() -> void:
	Save.song_number = 1
	get_tree().change_scene_to_packed(time_scale_scene)


func _on_stage_2_pressed() -> void:
	Save.song_number = 2
	get_tree().change_scene_to_packed(time_scale_scene)


func _on_stage_3_pressed() -> void:
	Save.song_number = 3
	get_tree().change_scene_to_packed(time_scale_scene)
