extends Control

@onready var menu_container = preload("res://Scenes/menu_container.tscn")
@onready var resume_button = $PanelContainer/VBoxContainer/ResumeButton
signal play
signal restart

func _ready() -> void: 
	resume_button.grab_focus()

func _on_resume_button_pressed() -> void:
	emit_signal("play")
	visible = false


func _on_restart_button_pressed() -> void:
	emit_signal("restart")
	
func _on_change_time_scale_button_pressed() -> void:
	var time_scale = load("res://Scenes/time_scale.tscn")
	get_tree().change_scene_to_packed(time_scale)


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(menu_container)

