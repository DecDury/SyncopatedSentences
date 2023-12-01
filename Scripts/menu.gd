extends Control
#@onready var stage = preload("res://Scenes/stage.tscn")

func _ready() -> void:
	$PanelContainer/VBoxContainer/StartButton.grab_focus()
	
func _on_visibility_changed() -> void:
	$PanelContainer/VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed() -> void:
	visible = false
	var stage_select
	var menu_container = get_node("../../MenuContainer")
	if (menu_container != null):
		print("In Menu Container")
		stage_select = menu_container.find_child("StageSelect")
		stage_select.visible = true
	else:
		print("Menu Container Not Found")
		stage_select = load("res://Scenes/stage_select.tscn")
		get_tree().change_scene_to_packed(stage_select)

func _on_quit_button_pressed() -> void:
	get_tree().quit()



