extends Control

@onready var stage = preload("res://Scenes/stage.tscn")

func _ready() -> void:
	$PanelContainer/HBoxContainer/Done.grab_focus()
	Save.time_scale = 1.0


func _on_spin_box_value_changed(value: float) -> void:
	Save.time_scale = value


func _on_done_pressed() -> void:
	get_tree().change_scene_to_packed(stage)
