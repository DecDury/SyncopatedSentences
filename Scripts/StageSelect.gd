extends Control

@onready var time_scale_scene = preload("res://Scenes/time_scale.tscn")

func _ready() -> void:
	var menu = get_node("../Menu")
	if menu == null:
		$PanelContainer/VBoxContainer/Stage1.grab_focus()

func _on_visibility_changed() -> void:
	$PanelContainer/VBoxContainer/Stage1.grab_focus()


func _on_stage_1_pressed() -> void:
	Save.song_number = 1
	load_next_scene()


func _on_stage_2_pressed() -> void:
	Save.song_number = 2
	load_next_scene()


func _on_stage_3_pressed() -> void:
	Save.song_number = 3
	load_next_scene()


func _on_stage_4_pressed() -> void:
	Save.song_number = 4
	load_next_scene()
	
func load_next_scene() -> void:
	visible = false
	var stage
	var menu_container = get_node("../../MenuContainer")
	if (menu_container != null):
		print("In Menu Container")
		stage = menu_container.find_child("TimeScale")
		stage.visible = true
	else:
		print("Menu Container Not Found")
		get_tree().change_scene_to_packed(time_scale_scene)
