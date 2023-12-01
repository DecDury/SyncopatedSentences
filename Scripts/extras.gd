extends Control

@onready var time_scale_scene = preload("res://Scenes/time_scale.tscn")

func _ready() -> void:
	var menu = get_node("../Menu")
	if menu == null:
		$PanelContainer/VBoxContainer/Stage1.grab_focus()

func _on_visibility_changed() -> void:
	$PanelContainer/VBoxContainer/Stage1.grab_focus()


func _on_stage_1_pressed() -> void:
	Save.song_number = 5
	load_next_scene("TimeScale")


func _on_stage_2_pressed() -> void:
	Save.song_number = 6
	load_next_scene("TimeScale")


func _on_stage_3_pressed() -> void:
	Save.song_number = 7
	load_next_scene("TimeScale")


func _on_back_to_menu_pressed() -> void:
	load_next_scene("Menu")


func load_next_scene(scene_name: String) -> void:
	visible = false
	var scene
	var menu_container = get_node("../../MenuContainer")
	if (menu_container != null):
		print("In Menu Container")
		scene = menu_container.find_child(scene_name)
		scene.visible = true
	else:
		print("Menu Container Not Found")
		get_tree().change_scene_to_packed(time_scale_scene)





