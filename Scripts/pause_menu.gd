extends Control

@onready var menu = preload("res://Scenes/menu.tscn")
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


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(menu)
