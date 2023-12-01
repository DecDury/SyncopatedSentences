extends Control

@onready var stage = preload("res://Scenes/stage.tscn")
var menu

func _ready() -> void:
	menu = get_node("../../MenuContainer")
	if menu == null:
		$PanelContainer/HBoxContainer/Done.grab_focus()
	Save.time_scale = 1.0
	
func _on_visibility_changed() -> void:
	$PanelContainer/HBoxContainer/Done.grab_focus()

func _on_spin_box_value_changed(value: float) -> void:
	Save.time_scale = value


func _on_done_pressed() -> void:
	if menu != null:
		var audio = menu.get_node("AudioStreamPlayer")
		audio.stop()
	get_tree().change_scene_to_packed(stage)



